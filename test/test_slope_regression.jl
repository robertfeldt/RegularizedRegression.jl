using RegularizedRegression: SlopeRegression, learn, coefficients

@testset "Slope regression" begin
    for _ in 1:NumTestRepetitions
        test_learner(SlopeRegression, 15.0) # Seems this needs to be higher for SLOPE than for SCAD and MCP
    end
end
