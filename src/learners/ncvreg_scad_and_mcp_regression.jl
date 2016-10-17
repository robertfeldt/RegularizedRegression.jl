# Make sure the ncvreg R library is loaded
load_R_library("ncvreg")

const NcvregDefaultParams = Dict(
    :family => "gaussian", # "binomial", "posisson"
    :alpha => 1.0,
    :nlambda => 100,
    :eps => 0.01,
    :max_iter => 1000,
    :convex => true,
    :warn => true,
    :returnX => false,

    # The following params are set based on size of input array
    :lambda_min => 0.001,  # 0.001 if n > p, 0.05 otherwise

    # The following params are set based on which type of regression it is
    :penalty => "SCAD",    # "MCP", "lasso"
    :gamma => 3.7         # 3.7 when SCAD and 3.0 otherwise
)

# Both SCAD and MCP is implemented via ncvreg R library
abstract NcvRegression <: RegressionLearner

function learn(r::NcvRegression, dataset::DataSet)
    X = indepvars_as_row_major_matrix(dataset)
    y = depvar_as_vector(dataset)

    # Create params for this specific call based on default ones plus the ones for this
    # regression datum.
    default_params = copy(NcvregDefaultParams)
    set_parameters!(r, default_params, dataset)
    params = merge(default_params, r.params)

    # Now call ncvreg and copy back the result as a Dict
    retval = R"""
      p <- $params
      ncvreg($X, $y, family=p$family, penalty=p$penalty, 
        gamma=p$gamma,
        alpha=p$alpha, lambda.min=p$lambda_min, nlambda=p$nlambda, 
        lambda=p$lambda, eps=p$eps, max.iter=p$max_iter, 
        convex=p$convex, warn=p$warn, returnX=p$returnX)
    """
    rcopy(retval)
end

function coefficients(r::NcvRegression, dataset::DataSet; includeIntercept = true)
    coeffs = learn(r, dataset)[:beta]
    includeIntercept ? coeffs : coeffs[2:end]
end

type ScadRegression <: NcvRegression
    params::Dict{Symbol, Any}
    ScadRegression(; params...) = new(Dict(params))
end

function set_parameters!(s::ScadRegression, params, ds::DataSet)
    params[:penalty] = "SCAD"
    params[:gamma] = 3.7
    set_lambda_min_param!(params, num_indepvars(ds), num_cases(ds))
    params
end

function set_lambda_min_param!(params, p::Int, n::Int)
    if n > p
        params[:lambda_min] = 0.001
    else
        params[:lambda_min] = 0.05
    end    
end

type McpRegression <: NcvRegression
    params::Dict{Symbol, Any}
    McpRegression(; params...) = new(Dict(params))
end

function set_parameters!(s::McpRegression, params, ds::DataSet)
    params[:penalty] = "MCP"
    params[:gamma] = 3.0
    set_lambda_min_param!(params, num_indepvars(ds), num_cases(ds))
    params
end
