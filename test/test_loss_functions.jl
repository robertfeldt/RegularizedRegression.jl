using RegularizedRegression: ape, medape, describe_goodness_of_fit

@testset "Loss functions" begin

@testset "APE (Absolute Percentage Error)" begin
    @test ape([1.5, 2.0], [1.0, 1.0]) == [0.50, 1.0]
    @test ape([1.5, 2.0, 3.0], [1.0, 1.0, 1.0]) == [0.50, 1.0, 2.0]
end

@testset "MAPE (Mean Absolute Percentage Error)" begin
    @test mape([1.5, 2.0], [1.0, 1.0]) == mean([50.0, 100.0])
    @test mape([1.5, 2.0, 3.0], [1.0, 1.0, 1.0]) == mean([50.0, 100.0, 200.0])
    @test isapprox(mape([1.5, 2.0, 3.0], [1.0, 1.5, 2.0]), mean([50.0, 100.0/3, 50.0]))
end

@testset "MEDAPE (Median Absolute Percentage Error)" begin
    @test medape([1.5, 2.0], [1.0, 1.0]) == median([50.0, 100.0])
    @test medape([1.5, 2.0, 3.0], [1.0, 1.0, 1.0]) == median([50.0, 100.0, 200.0])
end

@testset "MASE (Mean Absolute Scaled Error)" begin
    @test mase([1.5, 2.0, 3.0], [1.0, 1.5, 2.0]) == (0.5+0.5+1.0)/(3.0/2.0 * (0.5 + 0.5))
end

#@testset "R2" begin
#    @test r2([1.5, 2.0, 3.0], [1.0, 1.5, 2.0]) == (1.0 - ()
#end

@testset "describe_goodness_of_fit" begin
    str = describe_goodness_of_fit([1.5, 2.0, 3.0], [1.0, 1.5, 2.0])
    @test typeof(str) <: AbstractString
    @test ismatch(r"MAPE = 44.44%", str)
    @test ismatch(r"MASE = 1.33", str)
    @test ismatch(r"R2 = ", str)

    str_w_adj = describe_goodness_of_fit([1.5, 2.0, 3.0], [1.0, 1.5, 2.0], 1)
    @test ismatch(r"R2adj = ", str_w_adj)
end

end