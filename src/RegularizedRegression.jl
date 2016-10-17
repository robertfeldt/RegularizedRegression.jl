module RegularizedRegression

include(joinpath("utils", "load_R_library.jl"))

include("loss_functions.jl")

abstract DataSet
num_indepvars(ds::DataSet) = length(indepvars(ds))
include("matrix_dataset.jl")

# Different Regression algorithms all implement the abstract RegressionLearner interface.
abstract RegressionLearner
learn(l::RegressionLearner, ds::DataSet) = error("Not implemented!")

include(joinpath("learners", "ncvreg_scad_and_mcp_regression.jl"))

export mape, mase, r2, r2adjusted
#export ScadRegression, McpRegression, learn, coefficients

end # RegularizedRegression