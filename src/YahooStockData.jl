module YahooStockData

using Requests
using Base.Dates
using DataFrames

const fields = Dict(
"1_year_target" => "t8",
"200_sma" => "m4",
"50_sma" => "m3",
"52_week_high" => "k",
"52_week_low" => "j",
"52_week_range" => "w",
"after_hours_change" => "c8",
"annualized_gain" => "g3",
"ask_realtime" => "b2",
"ask_size" => "a5",
"average_daily_volume" => "a2",
"bid_realtime" => "b3",
"bid_size" => "b6",
"book_value" => "b4",
"change" => "c1",
"change_200_sma" => "m5",
"change_50_sma" => "m7",
"change_from_52_week_high" => "k4",
"change_from_52_week_low" => "j5",
"change_percent" => "p2",
"change_percent_change" => "c",
"change_percent_realtime" => "k2",
"change_realtime" => "c6",
"commission" => "c3",
"company_name" => "n",
"dividend_pay_date" => "r1",
"dividend_per_share" => "d",
"dividend_yield" => "y",
"ebitda" => "j4",
"eps" => "e",
"eps_estimate_current_year" => "e7",
"eps_estimate_next_quarter" => "e9",
"eps_estimate_next_year" => "e8",
"ex_dividend_date" => "q",
"float_shares" => "f6",
"high_limit" => "l2",
"holdings_gain" => "g4",
"holdings_gain_percent" => "g1",
"holdings_gain_percent_realtime" => "g5",
"holdings_gain_realtime" => "g6",
"holdings_value" => "v1",
"holdings_value_realtime" => "v7",
"last_trade_date" => "d1",
"last_trade_price" => "l1",
"last_trade_realtime_time" => "k1",
"last_trade_size" => "k3",
"last_trade_time" => "t1",
"last_trade_time_plus" => "l",
"low_limit" => "l3",
"market_cap" => "j1",
"market_cap_realtime" => "j3",
"more_info" => "v",
"notes" => "n4",
"order_book_realtime" => "i5",
"pe" => "r",
"pe_realtime" => "r2",
"peg" => "r5",
"percent_change_200_sma" => "m6",
"percent_change_50_sma" => "m8",
"percent_change_from_52_week_high" => "k5",
"percent_change_from_52_week_low" => "j6",
"previous_close" => "p",
"price_book" => "p6",
"price_eps_estimate_current_year" => "r6",
"price_eps_estimate_next_year" => "r7",
"price_paid" => "p1",
"price_sales" => "p5",
"revenue" => "s6",
"shares_outstanding" => "j2",
"shares_owned" => "s1",
"short_ratio" => "s7",
"stock_exchange" => "x",
"ticker_trend" => "t7",
"today_open" => "o",
"todays_high" => "h",
"todays_low" => "g",
"todays_range" => "m",
"todays_range_realtime" => "m2",
"todays_value_change" => "w1",
"todays_value_change_realtime" => "w4",
"trade_date" => "d2",
"trade_links" => "t6",
"volume" => "v"
)

const inverted_fields = Dict{ASCIIString, ASCIIString}()
for (n,v) in fields
  sn = symbol("get_"*n)
  @eval begin
      function $(sn)(sym)
        get(sym, $v)
      end
  end
  inverted_fields[v] = n
end

get(sym::ByteString, fld::ByteString) =
  to_nullable(request_yahoo(sym, fld))
get(sym::ByteString, fld::Vector) =
  to_nullable_dict(fld, split(request_yahoo(sym, reduce(*, fld)), ","))
get(sym::ByteString) = get(sym, collect(values(fields)))

function request_yahoo(sym, fld)
  url = "http://finance.yahoo.com/d/quotes.csv?s=$sym&f=$fld"
  resp = Requests.get(url)
  r = readall(resp)
  return r
end

function get_historical(sym, startd, endd)

    q = Dict(
     "s" => sym,
     "a" => month(startd) - 1,
     "b" => dayofmonth(startd),
     "c" => year(startd),
     "d" => month(endd) - 1,
     "e" => dayofmonth(endd),
     "f" => year(endd),
     "g" => "d",
     "ignore" => ".csv"
    )
    url = "http://real-chart.finance.yahoo.com/table.csv"
    resp = Requests.get(url; query=q)
    return readtable(IOBuffer(readall(resp)))
end

function get_historical(sym::Vector, startd, endd)
  r = DataFrame()
  println("Fetching historical data from Yahoo \nfrom $startd to $endd for $(length(sym)) tickers")
  for (i,x) in enumerate(sym)
    println("$i of $(length(sym)) : $x")
    df=get_historical(x, startd, endd)
    df[:Ticker] = repmat([x], size(df, 1))
    if length(r) == 0
      r = df
    else
      r = vcat(r, df)
    end
  end
  return r
end

function to_nullable_dict{T<:AbstractString}(fld::Vector, x::Vector{T})
  r = Dict{ASCIIString, Nullable}()
  for (i, y)  in enumerate(x)
    r[inverted_fields[fld[i]]] = to_nullable(y)
  end
  return r
end

function to_nullable{T<:AbstractString}(x::T)
  try
    return Nullable(float(x))
  catch
    if x == "N/A"
      return Nullable{Float64}()
    else
      return Nullable(strip(x))
    end
  end
end

end # module
