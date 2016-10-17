using RegularizedRegression: MatrixDataSet, indepvars, depvar

@testset "MatrixDataSet" begin

@testset "Default names for indep and dep var(s), unless set" begin
    N = 10
    P = 3
    X = rand(P, N)
    y = X[1, :] .* 2.0

    m1 = MatrixDataSet(X, y)
    @test indepvars(m1) == [:x1, :x2, :x3]
    @test depvar(m1)    == :y

    m2 = MatrixDataSet(X, y; depvar = :othername)
    @test indepvars(m2) == [:x1, :x2, :x3]
    @test depvar(m2)    == :othername

    m3 = MatrixDataSet(X, y; indepvars = [:myname1, :x2, :n3])
    @test indepvars(m3) == [:myname1, :x2, :n3]
    @test depvar(m3)    == :y
end

end