using RegularizedRegression
using BaseTestNext
using Compat

const NumTestRepetitions = 30

using RegularizedRegression: learn, coefficients

function make_dataset(pRange, nRange, coefRange)
    N = rand(pRange)
    P = rand(nRange)
    X = randn(P, N)
    sel = rand(1:P)
    coef = rand(coefRange)
    y = X[sel, :] * coef
    ds = MatrixDataSet(X, y)
    return N, P, sel, X, y, ds
end

function test_learner_with_includeIntercept(learnertype, maxMape = 10.0)
    N, P, sel, X, y, ds = make_dataset(10:50, 2:8, 1.0:0.01:10.0)
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
    @test RegularizedRegression.mape(yhat, y) < maxMape # Accuracy should be very high since no noise
end

function test_learner(learnertype, maxMape = 10.0)
    N, P, sel, X, y, ds = make_dataset(10:50, 2:8, 1.0:0.01:10.0)
    l = learnertype()

    res = learn(l, ds)
    @test typeof(res) <: Dict

    beta = coefficients(l, ds)
    @test typeof(beta) <: Array
    @test length(beta) == P

    yhat = X' * beta
    @test RegularizedRegression.mape(yhat, y) < maxMape # Accuracy should be very high since no noise
end
