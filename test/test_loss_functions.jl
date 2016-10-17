using RegularizedRegression: mape

@testset "Loss functions" begin
    
@testset "MAPE" begin
    @test mape([1.5, 2.0], [1.0, 1.0]) == mean([50.0, 100.0])
    @test mape([1.5, 2.0, 3.0], [1.0, 1.0, 1.0]) == mean([50.0, 100.0, 200.0])
end

end