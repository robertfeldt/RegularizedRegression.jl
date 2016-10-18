# The SLOPE R library is GPL so cannot be directly included in this package. Instead
# we provide an installation and build function that users need to call manually.

SLOPE_CODE_URL = "http://www-stat.stanford.edu/~candes/SortedL1/SLOPE_code.tgz"
#SLOPEDestDir = joinpath(dirname(@__FILE__()), "slope_code")
SLOPEDestDir = "/Users/feldt/dev/RegularizedRegression.jl/src/utils/slope_code"
SLOPEUnpackDir = "SLOPE_code" # Name of the dir where the tar file unpacks to

using Requests
using RCall

# When this global var has been set to a string path the SLOPE code has been successfully loaded
global SLOPECodeInPathLoaded = false

function install_SLOPE_R_code(url = SLOPE_CODE_URL;
    destdir = SLOPEDestDir, unpackdir = SLOPEUnpackDir)

    # Make destdir if not already there
    if !isdir(destdir)
        mkdir(destdir)
    end

    cd(destdir) do
        tarball = download_SLOPE_code_tarball_and_save_to_file(url)

        # Unpack tarball
        res1 = readstring(`tar xvfz $tarball`)

        # Go into dir and...
        cd(unpackdir) do
            #...build c code into R callable code
            res2 = readstring(`R CMD SHLIB cproxSortedL1.c proxSortedL1.c`)

            #...indicate that we have built the SLOPE code
            global SLOPECodeInPathLoaded
            SLOPECodeInPathLoaded = joinpath(destdir, unpackdir)
        end
    end
end

function download_SLOPE_code_tarball_and_save_to_file(url)
    filename = "SLOPE_code.tgz"
    open(filename, "w") do fh
        write(fh, readbytes(get(url)))
    end
    return filename
end

function is_installed_SLOPE()
    global SLOPECodeInPathLoaded
    if SLOPECodeInPathLoaded != false
        isfile(joinpath(SLOPECodeInPathLoaded, "cproxSortedL1.so"))
    else
        false
    end
end

function load_SLOPE_R_lib()
    if !is_installed_SLOPE()
        install_SLOPE_R_code()
    end

    global SLOPECodeInPathLoaded
    RCall.reval("dyn.load('$SLOPECodeInPathLoaded/cproxSortedL1.so')")
    RCall.reval("source('$SLOPECodeInPathLoaded/proxSortedL1.R')")
    RCall.reval("source('$SLOPECodeInPathLoaded/Adlas.R')")
    res = RCall.reval("Adlas")
    typeof(res) == RCall.RObject{RCall.ClosSxp}
end
