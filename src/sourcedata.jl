
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
`SourceData(srcfile, package_name, dataset_name, title, zipfile, rows, columns, description, timestamps)`


`srcfile` is the path to the source file, the `package_name` will be the folder that the file resides, the `dataset_name` will be the name of the data without extension.


If `timestamps` not specified, it will be `today()`.

# Example

```
srcfile = "data/raw/Category_A/Dataset_B.csv"
SD = SourceData(srcfile)
```
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
Construct a `DataFrame` following the order of `ordered_columns`.
"""
function SmallDatasetMaker.DataFrame(SD::SourceData)
    return DataFrame([col => getfield(SD, column_field_dictionary[col]) for col in ordered_columns])
end

"""
`SourceData(mod::Module, row::DataFrameRow)` applies create an `SourceData` objects from a row of a `DataFrame` (i.e., `dataset_table(mod)`), with `abspath!` applied.

This is for loading data according to `dataset_table`; thus, paths should be referred to that in mod instead of being relative to the current directory.
"""
function SourceData(mod::Module, row::DataFrameRow)
    SD = SourceData(
        row.RawData,    # srcfile::Union{Missing,String}
        row.PackageName,         # package_name::String
        row.Dataset,             # dataset_name::String
        row.Title,               # title::Union{Missing,String}
        row.ZippedData, # zipfile::String
        row.Rows,                # rows::Int
        row.Columns,             # columns::Int
        row.Description,         # description::Union{Missing,String}
        row.TimeStamp,           # timestamps::TimeType
        )
    abspath!(SD, mod)
    return SD
end



function SmallDatasetMaker.show(io::IO, SD::SourceData)
    row = DataFrame(SD) |> eachrow |> only
    show(io, PrettyTables.pretty_table(DataFrame(:Field => keys(row), :Content => collect(values(row)))))
end

"""
`relpath!(SD::SourceData, mod::Module)` makes all paths in `SD` to be relative path to `DATASET_ABS_DIR`.
"""
function relpath!(SD::SourceData, mod::Module)
    SD.srcfile = relpath(SD.srcfile, DATASET_ABS_DIR(mod)[])
    SD.zipfile = relpath(SD.zipfile, DATASET_ABS_DIR(mod)[])
end

"""
`abspath!(SD::SourceData, mod::Module)` makes all paths in `SD` to be absolute with the starting directory `DATASET_ABS_DIR`.
"""
function abspath!(SD::SourceData, mod::Module)
    SD.srcfile = abspath(mod, SD.srcfile)
    SD.zipfile = abspath(mod, SD.zipfile)
end
