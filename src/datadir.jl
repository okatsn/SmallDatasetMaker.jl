

# These functions are applied only for package internal use.

"""
Path to the directory "data/raw/" of module `mod`; the default directory for the raw data.
"""
dir_raw(mod::Module, args...) = joinpath(DATASET_ABS_DIR(mod)[], "data", "raw", args...)


"""
Absolute path to the directory of data.
"""
dir_data(mod::Module, args...) = joinpath(DATASET_ABS_DIR(mod)[], "data", args...)


"""
Relative path to the directory of data; this is called by `SourceData`.
"""
dir_data(args...) = joinpath("data", args...)

"""
Given path to the source file, `get_package_dataset_name(srcpath)` derive package name and dataset name from the `srcpath`.

# Example
```jldoctest
srcpath = joinpath("Whatever", "RDatasets", "iris.csv")
SmallDatasetMaker.get_package_dataset_name(srcpath)

# output

("RDatasets", "iris")
```

"""
function get_package_dataset_name(srcpath)
    package_name = srcpath |> dirname |> basename
    dataset_name = srcpath |> basename |> str -> split(str, "."; limit=2) |> first
    return (package_name, dataset_name)
end
