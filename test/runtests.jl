if !isdefined(:TimeTestExecution)
    const TimeTestExecution = false
end

module RegularizedRegressionTests

startclocktime = time()
include("helper.jl")

import Compat.String

my_tests = [
    "test_loss_functions.jl",

    "test_matrix_dataset.jl",

    "test_scad_and_mcp_regression.jl",
    "test_slope_regression.jl",
    "test_glmnet_lasso_and_ridge_regression.jl",
]

if Main.TimeTestExecution

# readstring not available pre 0.5:
if VERSION < v"0.5.0"
    readstring(stream) = readall(stream)
end

function get_git_remote_and_branch()
    lines = split(readstring(`git remote -v show`), "\n")
    remote = match(r"[a-z0-9]+\s+([^\s]+)", lines[1]).captures[1]
    branch = strip(readstring(`git rev-parse --abbrev-ref HEAD`))
    commit = strip(readstring(`git rev-parse HEAD`))
    return remote, branch, commit
end

gitremote, gitbranch, gitcommit = get_git_remote_and_branch()
gitstr = gitremote * "/" * gitbranch * "/" * gitcommit[1:6]
versionstr = string(VERSION)

using DataFrames

TestTimingFileName = "test/timing_testing.csv"

if isfile("test/timing_testing.csv")
    timing_data = readtable("test/timing_testing.csv")
else
    timing_data = DataFrame(TimeStamp = AbstractString[], Julia = AbstractString[], Git = AbstractString[], TestFile = AbstractString[], Elapsed = Float64[])
end

end

using CPUTime

numtestfiles = 0
starttime = CPUtime_us()
@testset "RegularizedRegression test suite" begin

for t in my_tests
    if Main.TimeTestExecution
        CPUtic()

        # Including the test file runs the tests in there...
        include(t)

        elapsed = CPUtoq()
        datestr = Libc.strftime("%Y%m%d %H:%M.%S", time())
        push!(timing_data, [datestr, versionstr, gitstr, t, elapsed])
    else
        include(t)
    end
    numtestfiles += 1
    print("."); flush(STDOUT);
end

end
elapsed = float(CPUtime_us() - starttime)/1e6

if Main.TimeTestExecution
    datestr = Libc.strftime("%Y%m%d %H:%M.%S", time())
    using SHA
    hash = bytes2hex(sha512(join(map(fn -> readstring(open(joinpath("test", fn))), my_tests))))[1:16]
    push!(timing_data, [datestr, versionstr, gitstr, "TOTAL TIME for $(length(my_tests)) test files, $(hash)", elapsed])
    writetable(TestTimingFileName, timing_data)
    println("Wrote $(nrow(timing_data)) rows to file $TestTimingFileName")
end

elapsedclock = time() - startclocktime
println("Tested $(numtestfiles) files in $(round(elapsedclock, 1)) seconds.")

end # module RegRegTests
