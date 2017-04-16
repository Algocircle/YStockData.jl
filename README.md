# Download securities data from Yahoo Finance

[![Build Status](https://travis-ci.org/Algocircle/YStockData.jl.svg?branch=master)](https://travis-ci.org/Algocircle/YStockData.jl)


## Installation

This package is not yet in the official package repository. Therefore, to install, use the following invocation
`Pkg.clone("https://github.com/Algocircle/YStockData.jl")`

## Usage

Yahoo Finance generally supports two different mechanisms for querying security data.
The first returns current values for a set of fields, for a given ticker. In this package
these can be retrieved by using a series of `get_xxx` methods, which take a ticker as an
argument, and returns a `Nullable` value as a result. Each field supported by Yahoo has a
corresponding `get...` method. For example:

```julia
julia> using YStockData

julia> YStockData.get_previous_close("IBM")
Nullable(136.75)

julia> YStockData.get_company_name("IBM")
Nullable("International Business Machines")
```
A higher level function, `get` retrieves all available fields, and returns the result as a
Dictionary.

```julia
julia> YStockData.get("IBM")
Dict{ASCIIString,Nullable{T}} with 82 entries:
  "eps_estimate_next_year"          => Nullable(15.11)
  "todays_range_realtime"           => Nullable{Float64}()
  "commission"                      => Nullable{Float64}()
  "book_value"                      => Nullable(13.7)
  "eps_estimate_next_quarter"       => Nullable(2.95)
  "ask_size"                        => Nullable(200.0)
  "bid_size"                        => Nullable(200.0)
  "percent_change_from_52_week_low" => Nullable("+3.87%")
  "last_trade_date"                 => Nullable("12/18/2015")
  "percent_change_200_sma"          => Nullable("-9.55%")
  "last_trade_time_plus"            => Nullable("11:23am - <b>136.75</b>")
  "price_book"                      => Nullable(9.98)
  "stock_exchange"                  => Nullable("NYQ")
  "ex_dividend_date"                => Nullable("11/6/2015")
  "last_trade_realtime_time"        => Nullable{Float64}()
  "last_trade_size"                 => Nullable(100.0)
  "change_200_sma"                  => Nullable(-14.43)
  "peg"                             => Nullable(1.26)
  "dividend_pay_date"               => Nullable("12/10/2015")
  "eps_estimate_current_year"       => Nullable(14.93)
  "today_open"                      => Nullable(136.41)
  "holdings_gain_percent_realtime"  => Nullable{Float64}()
  "ebitda"                          => Nullable("21.41B")
  "previous_close"                  => Nullable(136.75)
  "revenue"                         => Nullable("83.80B")
  "1_year_target"                   => Nullable(148.85)
  "annualized_gain"                 => Nullable{Float64}()
  "ticker_trend"                    => Nullable{Float64}()
  ⋮                                 => ⋮
```

The second mechanism returns OHLC time series values for a ticker and given time period.
This data is available via the `get_historical` function, which takes the ticker, a start
data and an end date as arguments. This function returns a `DataFrame` as its result.

```julia
YStockData.get_historical("IBM", now()-Year(1), now())
252x7 DataFrames.DataFrame
| Row | Date         | Open   | High   | Low    | Close  | Volume  | Adj_Close |
|-----|--------------|--------|--------|--------|--------|---------|-----------|
| 1   | "2015-12-17" | 139.35 | 139.5  | 136.31 | 136.75 | 4048600 | 136.75    |
| 2   | "2015-12-16" | 139.12 | 139.65 | 137.79 | 139.29 | 4313300 | 139.29    |
| 3   | "2015-12-15" | 137.4  | 138.97 | 137.28 | 137.79 | 4207900 | 137.79    |
| 4   | "2015-12-14" | 135.31 | 136.14 | 134.02 | 135.93 | 5103800 | 135.93    |
| 5   | "2015-12-11" | 135.23 | 135.44 | 133.91 | 134.57 | 5315200 | 134.57    |
| 6   | "2015-12-10" | 137.03 | 137.85 | 135.72 | 136.78 | 4754800 | 136.78    |
| 7   | "2015-12-09" | 137.38 | 139.84 | 136.23 | 136.61 | 4546600 | 136.61    |
| 8   | "2015-12-08" | 138.28 | 139.06 | 137.53 | 138.05 | 3859100 | 138.05    |
| 9   | "2015-12-07" | 140.16 | 140.41 | 138.81 | 139.55 | 3272000 | 139.55    |
| 10  | "2015-12-04" | 138.09 | 141.02 | 137.99 | 140.43 | 4504700 | 140.43    |
| 11  | "2015-12-03" | 140.1  | 140.73 | 138.19 | 138.92 | 5900900 | 138.92    |
| 12  | "2015-12-02" | 140.93 | 141.21 | 139.5  | 139.7  | 3707800 | 139.7     |
| 13  | "2015-12-01" | 139.58 | 141.4  | 139.58 | 141.28 | 4187400 | 141.28    |
⋮
| 239 | "2015-01-08" | 156.24 | 159.04 | 155.55 | 158.42 | 4236800 | 153.41    |
| 240 | "2015-01-07" | 157.2  | 157.2  | 154.03 | 155.05 | 4701800 | 150.147   |
| 241 | "2015-01-06" | 159.67 | 159.96 | 155.17 | 156.07 | 6146700 | 151.135   |
| 242 | "2015-01-05" | 161.27 | 161.27 | 159.19 | 159.51 | 4880400 | 154.466   |
| 243 | "2015-01-02" | 161.31 | 163.31 | 161.0  | 162.06 | 5525500 | 156.935   |
| 244 | "2014-12-31" | 160.41 | 161.5  | 160.38 | 160.44 | 4011900 | 155.366   |
| 245 | "2014-12-30" | 160.02 | 160.82 | 159.79 | 160.05 | 2829900 | 154.989   |
| 246 | "2014-12-29" | 162.0  | 162.34 | 159.45 | 160.51 | 3331800 | 155.434   |
| 247 | "2014-12-26" | 162.27 | 163.09 | 162.01 | 162.34 | 1912200 | 157.206   |
| 248 | "2014-12-24" | 162.88 | 162.99 | 161.61 | 161.82 | 1868100 | 156.703   |
| 249 | "2014-12-23" | 162.23 | 162.9  | 161.61 | 162.24 | 4043300 | 157.11    |
| 250 | "2014-12-22" | 158.33 | 161.91 | 158.33 | 161.44 | 4682500 | 156.335   |
| 251 | "2014-12-19" | 157.49 | 160.41 | 157.49 | 158.51 | 8864900 | 153.498   |
| 252 | "2014-12-18" | 153.58 | 157.68 | 153.3  | 157.68 | 7302400 | 152.694   |
```

The `get_historical` function also takes a Vector of tickers as input. The return value
in this case is also a dataframe, with the ticker as an additional column.

```julia
julia> YStockData.get_historical(["IBM", "YHOO", "GOOG"], now()-Year(1), now())
Fetching historical data from Yahoo
from 2014-12-18T16:41:53 to 2015-12-18T16:41:53 for 3 tickers
1 of 3 : IBM
2 of 3 : YHOO
3 of 3 : GOOG
756x8 DataFrames.DataFrame
| Row | Date         | Open    | High    | Low     | Close   | Volume  | Adj_Close | Ticker |
|-----|--------------|---------|---------|---------|---------|---------|-----------|--------|
| 1   | "2015-12-17" | 139.35  | 139.5   | 136.31  | 136.75  | 4048600 | 136.75    | "IBM"  |
| 2   | "2015-12-16" | 139.12  | 139.65  | 137.79  | 139.29  | 4313300 | 139.29    | "IBM"  |
| 3   | "2015-12-15" | 137.4   | 138.97  | 137.28  | 137.79  | 4207900 | 137.79    | "IBM"  |
| 4   | "2015-12-14" | 135.31  | 136.14  | 134.02  | 135.93  | 5103800 | 135.93    | "IBM"  |
| 5   | "2015-12-11" | 135.23  | 135.44  | 133.91  | 134.57  | 5315200 | 134.57    | "IBM"  |
| 6   | "2015-12-10" | 137.03  | 137.85  | 135.72  | 136.78  | 4754800 | 136.78    | "IBM"  |
| 7   | "2015-12-09" | 137.38  | 139.84  | 136.23  | 136.61  | 4546600 | 136.61    | "IBM"  |
| 8   | "2015-12-08" | 138.28  | 139.06  | 137.53  | 138.05  | 3859100 | 138.05    | "IBM"  |
| 9   | "2015-12-07" | 140.16  | 140.41  | 138.81  | 139.55  | 3272000 | 139.55    | "IBM"  |
| 10  | "2015-12-04" | 138.09  | 141.02  | 137.99  | 140.43  | 4504700 | 140.43    | "IBM"  |
| 11  | "2015-12-03" | 140.1   | 140.73  | 138.19  | 138.92  | 5900900 | 138.92    | "IBM"  |
| 12  | "2015-12-02" | 140.93  | 141.21  | 139.5   | 139.7   | 3707800 | 139.7     | "IBM"  |
| 13  | "2015-12-01" | 139.58  | 141.4   | 139.58  | 141.28  | 4187400 | 141.28    | "IBM"  |
⋮
| 743 | "2015-01-08" | 497.992 | 503.482 | 491.002 | 502.682 | 3353600 | 502.682   | "GOOG" |
| 744 | "2015-01-07" | 507.002 | 507.246 | 499.652 | 501.102 | 2065100 | 501.102   | "GOOG" |
| 745 | "2015-01-06" | 515.002 | 516.177 | 501.052 | 501.962 | 2899900 | 501.962   | "GOOG" |
| 746 | "2015-01-05" | 523.262 | 524.332 | 513.062 | 513.872 | 2059800 | 513.872   | "GOOG" |
| 747 | "2015-01-02" | 529.012 | 531.272 | 524.102 | 524.812 | 1447600 | 524.812   | "GOOG" |
| 748 | "2014-12-31" | 531.252 | 532.602 | 525.802 | 526.402 | 1368200 | 526.402   | "GOOG" |
| 749 | "2014-12-30" | 528.092 | 531.152 | 527.132 | 530.422 | 876300  | 530.422   | "GOOG" |
| 750 | "2014-12-29" | 532.192 | 535.482 | 530.013 | 530.332 | 2278500 | 530.332   | "GOOG" |
| 751 | "2014-12-26" | 528.772 | 534.252 | 527.312 | 534.032 | 1036000 | 534.032   | "GOOG" |
| 752 | "2014-12-24" | 530.512 | 531.761 | 527.022 | 528.772 | 705900  | 528.772   | "GOOG" |
| 753 | "2014-12-23" | 527.002 | 534.562 | 526.292 | 530.592 | 2197600 | 530.592   | "GOOG" |
| 754 | "2014-12-22" | 516.082 | 526.462 | 516.082 | 524.872 | 2723800 | 524.872   | "GOOG" |
| 755 | "2014-12-19" | 511.512 | 517.722 | 506.913 | 516.352 | 3690200 | 516.352   | "GOOG" |
| 756 | "2014-12-18" | 512.952 | 513.872 | 504.702 | 511.102 | 2926700 | 511.102   | "GOOG" |
```

## Disclaimer

Yahoo is a registered trademark of Yahoo Inc. This codebase is provided as is, without any
warranties, or claims of fitness. It is not affiliated with or endorsed by Yahoo in any way.

You are responsible for adhering to all usage terms and restrictions for Yahoo Finance.
