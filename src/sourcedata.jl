
mutable struct SourceData
    srcfile::Union{Missing,String}
    package_name::String
    dataset_name::String
    title::Union{Missing,String}
    zipfile::String
    rows::Int
    columns::Int
    description::Union{Missing,String}
    timestamps::TimeType
end



"""
SourceData(srcfile, package_name, dataset_name, title, zipfile, rows, columns, description, timestamps)


`srcfile` is the path to the source file, the `package_name` will be the folder that the file resides, the `dataset_name` will be the name of the data without extension.


If `timestamps` not specified, it will be `today()`.
"""
function SourceData(srcfile, package_name, dataset_name, title, zipfile, rows, columns, description)
    SourceData(srcfile, package_name, dataset_name, title, zipfile, rows, columns, description, today())
end

"""
If `description` not specified, it will be `""`.
"""
function SourceData(srcfile, package_name, dataset_name, title, zipfile, rows, columns)
    SourceData(srcfile, package_name, dataset_name, title, zipfile, rows, columns, "")
end

"""
If `rows, columns` not specified, `CSV.read(srcfile, DataFrame)` will be applied to get the number of rows/columns.
"""
function SourceData(srcfile, package_name, dataset_name, title, zipfile)
    df = CSV.read(srcfile, DataFrame)
    (rows, columns) = (nrow(df), ncol(df))
    SourceData(srcfile, package_name, dataset_name, title, zipfile, rows, columns)
end


"""
If `zipfile` not specified, it will be `dir_data(package_name, dataset_name*".gz")`.
"""
function SourceData(srcfile, package_name, dataset_name, title)
    zipfile = dir_data(package_name, dataset_name*".gz")
    SourceData(srcfile, package_name, dataset_name, title, zipfile)
end


"""
If `title` not specified, it will be `"Data [\$dataset_name] of [\$package_name]"`.
"""
function SourceData(srcfile, package_name, dataset_name)
    title = "Data [$dataset_name] of [$package_name]"
    SourceData(srcfile, package_name, dataset_name, title)
end


"""
If `package_name, dataset_name` not specified, `(package_name, dataset_name) = get_package_dataset_name(srcfile)` is applied.
"""
function SourceData(srcfile)
    (package_name, dataset_name) = get_package_dataset_name(srcfile)
    SourceData(srcfile, package_name, dataset_name)
end

"""
`SourceData(mod::Module, args...)`. Same as above, but `joinpath` the directory `zipfile` with `DATASET_ABS_DIR(mod::Module)`. See also `abspath`.
"""
function SourceData(mod::Module, args...)
    SD = SourceData(args...)
    # make paths referencing `DATASET_ABS_DIR(mod::Module)`
    abspathmod(x) = abspath(mod, x)
    # SD.srcfile = abspathmod(SD.srcfile) # You cannot redefine source since it is a must for SourceData interface.
    SD.zipfile = abspathmod(SD.zipfile)
    return SD
end

"""
Construct a `DataFrame` following the order of `ordered_columns`.
"""
function SmallDatasetMaker.DataFrame(SD::SourceData)
    return DataFrame([col => getfield(SD, column_field_dictionary[col]) for col in ordered_columns])
end

"""
`SourceData(mod::Module, row::DataFrameRow)` applies `abspath(mod, x)`.
This is for loading data according to dataset_table, thus, srcfile should be referred to that in mod.
"""
function SourceData(mod::Module, row::DataFrameRow)
    abspathmod(x) = abspath(mod, x)
    SourceData(
        abspathmod(row.RawData),    # srcfile::Union{Missing,String}
        row.PackageName,         # package_name::String
        row.Dataset,             # dataset_name::String
        row.Title,               # title::Union{Missing,String}
        abspathmod(row.ZippedData), # zipfile::String
        row.Rows,                # rows::Int
        row.Columns,             # columns::Int
        row.Description,         # description::Union{Missing,String}
        row.TimeStamp,           # timestamps::TimeType
        )
end

"""
`SourceData(row::DataFrameRow)` returns
```julia
SourceData(
    abspath(row.RawData),    # srcfile::Union{Missing,String}
    row.PackageName,         # package_name::String
    row.Dataset,             # dataset_name::String
    row.Title,               # title::Union{Missing,String}
    abspath(row.ZippedData), # zipfile::String
    row.Rows,                # rows::Int
    row.Columns,             # columns::Int
    row.Description,         # description::Union{Missing,String}
    row.TimeStamp,           # timestamps::TimeType
    )
```
"""
function SourceData(row::DataFrameRow)
    SourceData(SmallDatasetMaker, row::DataFrameRow)
end

function SmallDatasetMaker.show(io::IO, SD::SourceData)
    row = DataFrame(SD) |> eachrow |> only
    show(io, PrettyTables.pretty_table(DataFrame(:Field => keys(row), :Content => collect(values(row)))))
end
