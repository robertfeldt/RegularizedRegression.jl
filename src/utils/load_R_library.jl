using RCall

function load_R_library(libname)
    reval("library($libname)")
end
