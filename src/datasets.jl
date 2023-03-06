"""
`DATASET_ABS_DIR(mod::Module)` returns the absolute directory for package `mod`.
"""
DATASET_ABS_DIR(mod::Module) = Ref{String}(dirname(dirname(pathof(mod)))) # FIXME: Absolute path


"""
`DATASET_ABS_DIR()[]` returns the absolute directory for package `SmallDatasetMaker`. Also see `abspath`.
"""
DATASET_ABS_DIR() = DATASET_ABS_DIR(SmallDatasetMaker)

"""
`abspath(mod::Module, args...) = joinpath(DATASET_ABS_DIR(mod)[], args...)`
"""
abspath(mod::Module, args...) = joinpath(DATASET_ABS_DIR(mod)[], args...)

"""
`abspath(args...) = joinpath(DATASET_ABS_DIR()[], args...)`
"""
abspath(args::String...) = abspath(SmallDatasetMaker, args...)


"""
`dataset_dir(mod::Module, args::String...)` returns the absolute dataset path referencing `mod`.
"""
dataset_dir(mod::Module, args::String...) = joinpath(DATASET_ABS_DIR(mod)[], "data", args...)

"""
Absolute path to the "data" of `SmallDatasetMaker`. See also `DATASET_ABS_DIR`.

# Example
```julia
`dataset_dir("doc", "datasets.csv")`

# Output
"~/.julia/dev/SmallDatasetMaker/data/doc/datasets.csv"
```
"""
dataset_dir(args::String...) = dataset_dir(SmallDatasetMaker, args...)


"""
`dataset_table(mod::Module) = joinpath(DATASET_ABS_DIR(mod)[],"data", "doc", "datasets.csv")`


"""
dataset_table(mod::Module) = joinpath(DATASET_ABS_DIR(mod)[],"data", "doc", "datasets.csv")

"""
`dataset_table()`.

The path to the index table for datasets in `SmallDatasetMaker`.
If SmallDatasetMaker is added using `pkg> dev SmallDatasetMaker` in other project/environment, `dataset_table()` returns "~/.julia/dev/SmallDatasetMaker/src/../data/doc/datasets.csv".

The reason for `dataset_table` to be a function rather than a constant is that I can redefine it in the scope of test. See `test/compdecomp.jl`.

"""
dataset_table() = dataset_table(SmallDatasetMaker)




"""
`datasets()` returns the table of this dataset, and define the global variable `SmallDatasetMaker.__datasets` as this table.

Set `; update_table = true` to force update `SmallDatasetMaker.__datasets` with the `dataset_table()`; this keyword argument is intended to make some tests can work since in test `dataset_table()` is mutating. # todo: find a better way to deal with it.
"""
function datasets(;update_table = false)
    if SmallDatasetMaker.__datasets === nothing || update_table
        global __datasets = DataFrame(CSV.File(dataset_table()))
    end
    return SmallDatasetMaker.__datasets::DataFrame
end

"""
`target_row` returns the latest information in `datasets()`.
Given `package_name, dataset_name`, `target_row(package_name, dataset_name)`, `target_row` returns the last `row` that matches `row.PackageName == package_name && row.Dataset == dataset_name"`.

"""
function target_row(package_name, dataset_name; kwargs...)
    indextable = SmallDatasetMaker.datasets(; kwargs...)
    row = filter([:PackageName, :Dataset] => (p, d) -> p == package_name && d == dataset_name , indextable) |> eachrow |> last
end

"""
Initiate referencing table at `dataset_table(args...)`.
It takes exactly the same arguments of `dataset_table`.
"""
function create_empty_table(args...)
    fpath = SmallDatasetMaker.dataset_table(args...)
    if isfile(fpath)
        error("$(fpath) already exists.")
    else
        fpath |> dirname |> mkpath # make directories along the way
        DataFrame( [col => String[] for col in ordered_columns]) |> df -> CSV.write(fpath, df)
    end
end
