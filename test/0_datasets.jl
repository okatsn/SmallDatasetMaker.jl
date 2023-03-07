# """
# `SourceData(row::DataFrameRow)` returns
# ```julia
# SourceData(
#     abspath(row.RawData),    # srcfile::Union{Missing,String}
#     row.PackageName,         # package_name::String
#     row.Dataset,             # dataset_name::String
#     row.Title,               # title::Union{Missing,String}
#     abspath(row.ZippedData), # zipfile::String
#     row.Rows,                # rows::Int
#     row.Columns,             # columns::Int
#     row.Description,         # description::Union{Missing,String}
#     row.TimeStamp,           # timestamps::TimeType
#     )
# ```
# """
# function SmallDatasetMaker.SourceData(row::DataFrameRow)
#     SourceData(SmallDatasetMaker, row::DataFrameRow)
# end


"""
`DATASET_ABS_DIR()[]` returns the absolute directory for package `SmallDatasetMaker`. Also see `abspath`.
"""
SmallDatasetMaker.DATASET_ABS_DIR() = DATASET_ABS_DIR(SmallDatasetMaker)


SmallDatasetMaker.unzip_file(package_name::AbstractString, dataset_name::AbstractString; kwargs...) = unzip_file(SmallDatasetMaker, package_name::AbstractString, dataset_name::AbstractString; kwargs...)

SmallDatasetMaker.dataset(package_name::AbstractString, dataset_name::AbstractString; kwargs...) = dataset(SmallDatasetMaker,package_name::AbstractString, dataset_name::AbstractString; kwargs...)


function SmallDatasetMaker.compress_save!(SD::SourceData; kwargs...)
    compress_save!(SmallDatasetMaker, SD; kwargs...)
end


function SmallDatasetMaker.compress_save(srcpath; args...)
    compress_save(SmallDatasetMaker, srcpath)
end

SmallDatasetMaker.dir_raw(args...) = joinpath(SmallDatasetMaker, "data", "raw", args...)



"""
`abspath(args...) = joinpath(DATASET_ABS_DIR()[], args...)`
"""
SmallDatasetMaker.abspath(args::String...) = SmallDatasetMaker.abspath(SmallDatasetMaker, args...)


"""
`dataset_table()`.

The path to the index table for datasets in `SmallDatasetMaker`.
If SmallDatasetMaker is added using `pkg> dev SmallDatasetMaker` in other project/environment, `dataset_table()` returns "~/.julia/dev/SmallDatasetMaker/src/../data/doc/datasets.csv".
"""
SmallDatasetMaker.dataset_table() = SmallDatasetMaker.dataset_table(SmallDatasetMaker)

"""
Absolute path to the "data" of `SmallDatasetMaker`. See also `DATASET_ABS_DIR`.

# Example
```julia
`dataset_dir("doc", "datasets.csv")`

# Output
"~/.julia/dev/SmallDatasetMaker/data/doc/datasets.csv"
```
"""
SmallDatasetMaker.dataset_dir(args::String...) = SmallDatasetMaker.dataset_dir(SmallDatasetMaker, args...)

SmallDatasetMaker.create_empty_table() = create_empty_table(SmallDatasetMaker)
SmallDatasetMaker.datasets() = SmallDatasetMaker.datasets(SmallDatasetMaker)

@testset "datasets.jl" begin
    using DataFrames
    # There should be no datasets.csv, and thus raise an expected error.
    @test try
        SmallDatasetMaker.datasets(SmallDatasetMaker);
        false;
    catch e
        true;
    end

    # Create an empty datasets.csv.
    create_empty_table() # in fact, error will occur if there is a file already.

    # # Even if it is created, .__datasets should be nothing until the first call of SmallDatasetMaker.datasets()
    @test !isdefined(SmallDatasetMaker, :__datasets)

    df = SmallDatasetMaker.datasets()
    @test isa(df, DataFrame)
    @test isa(SmallDatasetMaker.__datasets, DataFrame)
    rm(SmallDatasetMaker.dataset_table())
end
