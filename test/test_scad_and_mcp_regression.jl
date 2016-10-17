using RegularizedRegression: ScadRegression, McpRegression, learn, coefficients

function test_learner(learnertype)
    N = rand(10:50)
    P = rand(2:8)
    X = randn(P, N)
    sel = rand(1:P)
    coef = rand(1.0:0.01:10.0)
    y = X[sel, :] * coef
    ds = MatrixDataSet(X, y)
    l = learnertype()

    res = learn(l, ds)
    @test typeof(res) <: Dict

    beta = coefficients(l, ds)
    @test typeof(beta) <: Array
    @test length(beta) == P+1

    beta2 = coefficients(l, ds; includeIntercept = false)
    @test typeof(beta2) <: Array
    @test length(beta2) == P

    yhat = X' * beta2
    @test RegularizedRegression.mape(yhat, y) < 5.0 # Accuracy should be very high since no noise
end

@testset "SCAD regression" begin
    for _ in 1:NumTestRepetitions
        test_learner(ScadRegression)
    end
end

@testset "MCP regression" begin
    for _ in 1:NumTestRepetitions
        test_learner(McpRegression)
    end
end
