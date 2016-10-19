using GLMNet

const GLMNetDefaultParams = Dict(
    :alpha       => 1.0,  # 1.0 means lasso regression, 0.0 means Ridge regression
    :tol         => 1e-7, # convergence criterion
    :standardize => true, # standardize predictors? (beta values always returned on orig scale regardless of this.)
)

abstract GLMNetRegression <: RegressionLearner

# Result is saved
type GLMNetRegressionResult <: RegressionResult
    cv
    best_model::Int
    GLMNetRegressionResult(cv) = new(cv, indmin(cv.meanloss))
end

function coefficients(res::GLMNetRegressionResult)
    res.cv.path.betas[:, res.best_model]
end

function learn(r::GLMNetRegression, dataset::DataSet)
    X = indepvars_as_row_major_matrix(dataset)
    y = depvar_as_vector(dataset)

    # Create params for this specific call based on default ones plus the ones for this
    # regression datum.
    default_params = copy(GLMNetDefaultParams)
    set_parameters!(r, default_params, dataset)
    params = merge(default_params, r.params)

    # Now call GLMNet
    cv = glmnetcv(X, y)
    GLMNetRegressionResult(cv)
end

function coefficients(r::GLMNetRegression, dataset::DataSet)
    res = learn(r, dataset)
    coefficients(res)
end

type LassoRegression <: GLMNetRegression
    params::Dict{Symbol, Any}
    LassoRegression(; params...) = new(Dict(params))
end

function set_parameters!(s::LassoRegression, params, ds::DataSet)
    params[:alpha] = 1.0
    params
end

type RidgeRegression <: GLMNetRegression
    params::Dict{Symbol, Any}
    RidgeRegression(; params...) = new(Dict(params))
end

function set_parameters!(s::RidgeRegression, params, ds::DataSet)
    params[:alpha] = 0.0
    params
end
