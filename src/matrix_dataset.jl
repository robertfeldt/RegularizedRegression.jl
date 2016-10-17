type MatrixDataSet{N} <: DataSet
    X::Array{N, 2}
    y::Array{N, 1}
    indepvars::Vector{Symbol}
    depvar::Symbol
end

# A matrix data set is given the X matrix and the y vector explicitly and can (optionally)
# be given names of the independent vars as well as the dependent var.
function MatrixDataSet{N <: Number}(X::Array{N, 2}, y::Array{N, 1}; indepvars = nothing, depvar = :y)
    @assert length(y) == size(X, 2)
    if indepvars == nothing
        indepvars = map(i -> Symbol("x$i"), 1:size(X, 1))
    end
    MatrixDataSet{eltype(X)}(X, y, indepvars, depvar)
end

function MatrixDataSet{N <: Number}(X::Array{N, 2}, y::Array{N, 2}, names = nothing)
    @assert size(y, 1) == 1 || size(y, 2) == 1
    MatrixDataSet(X, y[:], names)
end

indepvars(m::MatrixDataSet) = m.indepvars
depvar(m::MatrixDataSet) = m.depvar
as_matrices(m::MatrixDataSet) = return m.X, m.y
num_cases(m::MatrixDataSet) = size(m.X, 2)
indepvars_as_row_major_matrix(m::MatrixDataSet) = m.X'
depvar_as_vector(m::MatrixDataSet) = m.y