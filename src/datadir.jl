

# These functions are applied only for package internal use.

"""
Path to the directory for the to-be-compressed data; only for package internal use.
"""
dir_to_be_converted(args...) = joinpath("data", "to_be_converted", args...) # TODO: delete me and all related code


"""
Path to the directory for the backup of the raw data; only for package internal use.
"""
dir_raw(args...) = joinpath("data", "raw", args...)

"""
Path to the directory for the data.
"""
dir_data(args...) = joinpath("data", args...)



"""
Given path to the source file, `get_package_dataset_name(srcpath)` derive package name and dataset name from the `srcpath`.

# Example
```jldoctest
srcpath = joinpath("Whatever", "RDatasets", "iris.csv")
SWCDatasets.get_package_dataset_name(srcpath)

# output

("RDatasets", "iris")
```

"""
function get_package_dataset_name(srcpath)
    package_name = srcpath |> dirname |> basename
    dataset_name = srcpath |> basename |> str -> split(str, "."; limit=2) |> first
    return (package_name, dataset_name)
end
