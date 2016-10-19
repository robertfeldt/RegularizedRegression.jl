using RegularizedRegression: ScadRegression, McpRegression

@testset "SCAD regression" begin
    for _ in 1:NumTestRepetitions
        test_learner_with_includeIntercept(ScadRegression)
    end
end

@testset "MCP regression" begin
    for _ in 1:NumTestRepetitions
        test_learner_with_includeIntercept(McpRegression)
    end
end
