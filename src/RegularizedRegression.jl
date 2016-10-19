module RegularizedRegression

include(joinpath("utils", "load_R_library.jl"))
include(joinpath("utils", "install_SLOPE_R_code.jl"))

include("loss_functions.jl")

abstract DataSet
num_indepvars(ds::DataSet) = length(indepvars(ds))
include("matrix_dataset.jl")

# Different Regression algorithms all implement the abstract RegressionLearner interface.
abstract RegressionLearner
abstract RegressionResult
learn(l::RegressionLearner, ds::DataSet) = error("Not implemented!")

include(joinpath("learners", "ncvreg_scad_and_mcp_regression.jl"))
include(joinpath("learners", "slope_regression.jl"))
include(joinpath("learners", "glmnet_lasso_and_ridge_regression.jl"))

export mape, mase, r2, r2adjusted
#export ScadRegression, McpRegression, learn, coefficients

end # RegularizedRegression