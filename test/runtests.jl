using YStockData
using Base.Test
using Base.Dates
using DataFrames

# write your own tests here
@test typeof(YStockData.get_previous_close("IBM").value) == Float64
@test typeof(YStockData.get_company_name("IBM").value) <: AbstractString
typeof(YStockData.get("IBM")["previous_close"].value) == Float64

@test size(YStockData.get_historical("IBM", now()-Year(1), now()), 1) > 200
@test size(YStockData.get_historical(["IBM", "YHOO"], now()-Year(1), now()), 1) > 400
