using RegularizedRegression: SlopeRegression, learn, coefficients

@testset "Slope regression" begin
    for _ in 1:NumTestRepetitions
        test_learner(SlopeRegression, 10.0)
    end
end
