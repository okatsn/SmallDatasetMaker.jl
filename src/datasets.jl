"""
`DATASET_ABS_DIR(mod::Module)` returns the absolute directory for package `mod`.
"""
DATASET_ABS_DIR(mod::Module) = Ref{String}(dirname(dirname(pathof(mod)))) # FIXME: Absolute path

"""
`abspath(mod::Module, args...) = joinpath(DATASET_ABS_DIR(mod)[], args...)`
"""
abspath(mod::Module, args...) = joinpath(DATASET_ABS_DIR(mod)[], args...)



"""
`dataset_dir(mod::Module, args::String...)` returns the absolute dataset path referencing `mod`.
"""
dataset_dir(mod::Module, args::String...) = joinpath(DATASET_ABS_DIR(mod)[], "data", args...)




"""
`dataset_table(mod::Module) = joinpath(DATASET_ABS_DIR(mod)[],"data", "doc", "datasets.csv")`

The reason for `dataset_table` to be a function rather than a constant is that I can redefine it in the scope of test. See `test/compdecomp.jl`.


"""
dataset_table(mod::Module) = joinpath(DATASET_ABS_DIR(mod)[],"data", "doc", "datasets.csv")



"""
`datasets(mod::Module)` returns the table of this dataset.
"""
function datasets(mod::Module)
    # if SmallDatasetMaker.__datasets === nothing || update_table
        # global __datasets = DataFrame(CSV.File(dataset_table(mod))) # , and define the global variable `SmallDatasetMaker.__datasets` as this table
        __datasets = DataFrame(CSV.File(dataset_table(mod)))
    # end
    return __datasets::DataFrame
end
# Set `; update_table = true` to force update `SmallDatasetMaker.__datasets` with the `dataset_table(mod)`; this keyword argument is intended to make some tests can work since in test `dataset_table(mod)` is mutating. # todo: find a better way to deal with it.

"""
`target_row` returns the latest information in `datasets(mod::Module)`.
Given `package_name, dataset_name`, `target_row(mod, package_name, dataset_name)`, `target_row` returns the last `row` that matches `row.PackageName == package_name && row.Dataset == dataset_name"`.

"""
function target_row(mod::Module, package_name, dataset_name; kwargs...)
    indextable = SmallDatasetMaker.datasets(mod; kwargs...)
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
