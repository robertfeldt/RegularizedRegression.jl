const SlopeDefaultParams = Dict(
    :iterations => 10000,
    :verbosity  => 1,
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

    # Now call Adlas and copy back the result as a Dict
    retval = R"""
      p <- $params
      Adlas($X, $y, $lambda, options = p)
    """
    rcopy(retval)
end

function coefficients(r::SlopeRegression, dataset::DataSet; includeIntercept = true)
    coeffs = learn(r, dataset)[:x]
    includeIntercept ? coeffs : coeffs[2:end]
end