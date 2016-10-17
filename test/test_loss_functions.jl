using RegularizedRegression: ape, mape, medape, mase

@testset "Loss functions" begin

@testset "APE (Absolute Percentage Error)" begin
    @test ape([1.5, 2.0], [1.0, 1.0]) == [0.50, 1.0]
    @test ape([1.5, 2.0, 3.0], [1.0, 1.0, 1.0]) == [0.50, 1.0, 2.0]
end

@testset "MAPE (Mean Absolute Percentage Error)" begin
    @test mape([1.5, 2.0], [1.0, 1.0]) == mean([50.0, 100.0])
    @test mape([1.5, 2.0, 3.0], [1.0, 1.0, 1.0]) == mean([50.0, 100.0, 200.0])
end

@testset "MEDAPE (Median Absolute Percentage Error)" begin
    @test medape([1.5, 2.0], [1.0, 1.0]) == median([50.0, 100.0])
    @test medape([1.5, 2.0, 3.0], [1.0, 1.0, 1.0]) == median([50.0, 100.0, 200.0])
end

@testset "MASE (Mean Absolute Scaled Error)" begin
    @test mase([1.5, 2.0, 3.0], [1.0, 1.5, 2.0]) == (0.5+0.5+1.0)/(3.0/2.0 * (0.5 + 0.5))
end

end