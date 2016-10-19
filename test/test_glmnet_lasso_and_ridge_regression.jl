using RegularizedRegression: LassoRegression, RidgeRegression, learn, coefficients

@testset "Lasso regression (via GLMNet.jl)" begin
    for _ in 1:NumTestRepetitions
        test_learner(LassoRegression, 5.0) # Seems this needs to be higher for SLOPE than for SCAD and MCP
    end
end
