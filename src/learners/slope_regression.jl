const SlopeDefaultParams = Dict(
    :iterations => 10000,
    :verbosity  => 0, # Print intermediate info if > 0
    :optimIter  => 1,
    :gradIter   => 20,
    :tolInfeas  => 1e-6,
    :tolRelGap  => 1e-6,
    :xInit      => Float64[]
)

# Make sure the SLOPE code is downloaded and installncvreg R library is loaded
load_SLOPE_R_lib()

type SlopeRegression <: RegressionLearner
    params::Dict{Symbol, Any}
    SlopeRegression(; params...) = new(Dict(params))
end

function learn(r::SlopeRegression, dataset::DataSet)
    X = indepvars_as_row_major_matrix(dataset)
    y = depvar_as_vector(dataset)

    # Create params for this specific call based on default ones plus the ones for this
    # regression datum.
    default_params = copy(SlopeDefaultParams)
    params = merge(default_params, r.params)

    # Create lambda that needs to be as long as the num of coefficients we want to find
    numcoefs = size(X, 2)
    lambda = (1.0 / numcoefs) * collect(numcoefs:-1:1)

    # Now call Adlas and copy back the result as a Dict
    retval = R"Adlas($X, $y, $lambda, $params)"
    rcopy(retval)
end

function coefficients(r::SlopeRegression, dataset::DataSet; includeIntercept = true)
    coeffs = learn(r, dataset)[:x]
    includeIntercept ? coeffs : coeffs[2:end]
end