"""
Absolute directory for package `SWCDatasets`. Also see `abspath`.
"""
const DATASET_ABS_DIR = Ref{String}(dirname(dirname(pathof(SWCDatasets))))


"""
`abspath(args...) = joinpath(DATASET_ABS_DIR[], args...)`
"""
abspath(args...) = joinpath(DATASET_ABS_DIR[], args...)


"""
Absolute path to the "data" of `SWCDatasets`. See also `DATASET_ABS_DIR`.

# Example
```julia
`dataset_dir("doc", "datasets.csv")`

# Output
"~/.julia/dev/SWCDatasets/data/doc/datasets.csv"
```
"""
dataset_dir(args...) = joinpath(DATASET_ABS_DIR[], "data", args...)

"""
The path to the index table for datasets in `SWCDatasets`.
If SWCDatasets is added using `pkg> dev SWCDatasets` in other project/environment, `dataset_table()` returns "~/.julia/dev/SWCDatasets/src/../data/doc/datasets.csv".

The reason for `dataset_table` to be a function rather than a constant is that I can redefine it in the scope of test. See `test/compdecomp.jl`.

"""
dataset_table() = joinpath(DATASET_ABS_DIR[],"data", "doc", "datasets.csv")


"""
`datasets()` returns the table of this dataset, and define the global variable `SWCDatasets.__datasets` as this table.

Set `; update_table = true` to force update `SWCDatasets.__datasets` with the `dataset_table()`; this keyword argument is intended to make some tests can work since in test `dataset_table()` is mutating. # todo: find a better way to deal with it.
"""
function datasets(;update_table = false)
    if SWCDatasets.__datasets === nothing || update_table
        global __datasets = DataFrame(CSV.File(dataset_table()))
    end
    return SWCDatasets.__datasets::DataFrame
end

"""
`target_row` returns the latest information in `datasets()`.
Given `package_name, dataset_name`, `target_row(package_name, dataset_name)`, `target_row` returns the last `row` that matches `row.PackageName == package_name && row.Dataset == dataset_name"`.

"""
function target_row(package_name, dataset_name; kwargs...)
    indextable = SWCDatasets.datasets(; kwargs...)
    row = filter([:PackageName, :Dataset] => (p, d) -> p == package_name && d == dataset_name , indextable) |> eachrow |> last
end
