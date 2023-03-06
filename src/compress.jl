"""
`load_original(path::AbstractString)` opens `path` and return the read data.
"""
function load_original(path::AbstractString)
    original = open(path, "r") do io
        read(io)
    end
    return original
end

"""
`return_compressed(path::AbstractString)` returned compressed data.

# Example
```julia
compressed = return_compressed("data/data.csv")
```
"""
function return_compressed(path::AbstractString)
    open(path, "r") do io
        data = read(io)
        transcode(GzipCompressor, data)
    end
end

"""
`return_compressed(data::Vector{UInt8})` returned compressed data.

# Example
```julia
data = load_original("data/data.csv")
compressed = return_compressed(data)
```
"""
function return_compressed(data::Vector{UInt8})
    transcode(GzipCompressor, data)
end


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
`field_column_dictionary` follows the order of the field of Source data.
"""
const field_column_dictionary = OrderedDict(
    :srcfile => :RawData,    
    :package_name => :PackageName,
    :dataset_name => :Dataset,    
    :title => :Title,      
    :zipfile => :ZippedData, 
    :rows => :Rows,       
    :columns => :Columns,    
    :description => :Description,
    :timestamps => :TimeStamp
)

"""
The order for `dataset_table()`.
"""
const ordered_columns = [
    :PackageName,
    :Dataset,
    :Title,
    :Rows,
    :Columns,
    :Description,
    :TimeStamp,
    :RawData,
    :ZippedData
]

"""
`column_field_dictionary` follows the order of the field of Source data.
"""
const column_field_dictionary = OrderedDict(zip(values(field_column_dictionary), keys(field_column_dictionary)))


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
Construct a `DataFrame` following the order of `ordered_columns`.
"""
function SmallDatasetMaker.DataFrame(SD::SourceData)
    return DataFrame([col => getfield(SD, column_field_dictionary[col]) for col in ordered_columns])
end

"""
`SourceData(mod::Module, row::DataFrameRow)` applies `abspath(mod, x)`.
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


"""
`compress_save!(SD::SourceData; move_source = true)` compress the `SD.srcfile`, save the zipped one to `SD.zipfile`, and update the $(dataset_table()).
By default, `move_source = true` that the source file will be moved to `dir_raw()`.
"""
function compress_save!(SD::SourceData; move_source = true)

    compressed = return_compressed(SD.srcfile)
    target_path = SD.zipfile
    mkpath(dirname(target_path))
    open(target_path, "w") do io
        write(io, compressed)
        @info "Zipped file saved at $target_path"
    end

    if move_source
        target_raw = dir_raw(basename(SD.srcfile))
        if isfile(target_raw)
            ex = open(target_raw, "r") do io
                read(io)
            end

            current = open(SD.srcfile, "r") do io
                read(io)
            end
            @assert isequal(ex, current) "[move_source=$(move_source)] $(target_raw) already exists but it is different from $(SD.srcfile)."


            @info "$(target_raw) already exists and it is exactly the same as $(SD.srcfile). Remove the later."
            rm(SD.srcfile)

        else
            OkFiles.mkdirway(target_raw) # mkpath of dir_raw() in case it doesn't exists
            mv(SD.srcfile, target_raw)
        end
        SD.srcfile = target_raw
    end

    CSV.write(dataset_table(), SmallDatasetMaker.DataFrame(SD); append=true)
    @info "$(basename(dataset_table())) updated successfully."
end


"""
`compress_save(srcpath)` is equivalent to `compress_save!(SourceData(srcpath))` but returns `SD::SourceData`.

`compress_save` takes the same keyword arguments as `compress_save!`.
"""
function compress_save(srcpath; args...)
    SD = SourceData(srcpath)
    compress_save!(SD; args...)
    return SD
end


# TODO: rename functions
