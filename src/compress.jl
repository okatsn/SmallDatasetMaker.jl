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




# abstract type ModuleReferability end
# struct ModuleReferable <: ModuleReferability
# struct NotModuleReferable <: ModuleReferability

# is_module(x::Module) = ModuleReferable()
# is_module(x) = NotModuleReferable()

# function SourceData(args..., ::ModuleReferable)
#     SourceData(args...)
# end

# function SourceData(args..., ::NotModuleReferable)
#     SourceData(args...)
# end

# function SourceData(args...)
#     SourceData(args..., is_module(args[1]))
# end

# function compress_save!(SD::SourceData, ::ModuleReferable; kwargs...)

# end


# function compress_save!(SD::SourceData, ::NotModuleReferable; kwargs...)

# end

# function compress_save!(SD::SourceData; kwargs...)
#     ismod = is_module(SD);
#     compress_save!(SD, ismod; kwargs...)
# end

# CHECKPOINT: Consider bind ModuleReferable to SourceData

returned = "`SD::SourceData` of relative paths to `DATASET_ABS_DIR(mod)[]`"

"""
`compress_save!(mod::Module, SD::SourceData; move_source = true, targeting_mod = false)` compress the `SD.srcfile`, save the zipped one to `SD.zipfile`, and update the `dataset_table(mod)`.

Options:
- By default, `move_source = true` that the source file will be moved to `dir_raw()`.
- Set `targeting_mod = true` to make sure the compressed data is saved relative to the repo of `mod`. Default is `false`, which means you can compress and save the data to whatever directory you like.

`compress_save!` returns $returned, where
`relpath!` is applied that paths `SD` as well as `dataset_table(mod)` are modified to be relative.

# Example

```julia
using YourDatasets, SmallDatasetMaker
compress_save!(YourDatasets, SD; targeting_mod = true)
```

This do the followings:
1. Create zipped files under `data/` of package `YourDatasets` in `dev`elopment.
2. Move the source file `SD.srcfile` (i.e., the raw .csv data) to `dir_raw(YourDatasets, ...)` by default.
3. Add a new line to `SmallDatasetMaker.dataset_table(YourDatasets)` (update `data/doc/datasets.csv` of `YourDatasets`).

See also `SourceData`, `compress_save`.
"""
function compress_save!(mod::Module, SD::SourceData; move_source=true, targeting_mod = false)

    compressed = return_compressed(SD.srcfile)
    if targeting_mod # output data relative to the `mod`'s path.
        target_path = SmallDatasetMaker.abspath(mod, SD.zipfile)
        SD.zipfile = target_path
    else
        target_path = SD.zipfile
    end

    mkpath(dirname(target_path))
    open(target_path, "w") do io
        write(io, compressed)
        @info "Zipped file saved at $target_path"
    end # save compressed data in the absolute path of your in-dev package

    if move_source # srcfile (raw data) is preserved in folder to be .gitignored
        (pkgname, _) = get_package_dataset_name(SD.srcfile)
        target_raw = dir_raw(mod, pkgname, basename(SD.srcfile))
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
            @info "Raw data moved to $(target_raw)."
        end
        SD.srcfile = target_raw
    end

    relpath!(SD, mod)
    reftablepath = dataset_table(mod)
    dirdoc = dirname(reftablepath)
    if !isdir(dirdoc)
        mkpath(dirdoc) # if dirdoc does not exist, the following CSV.write will fail
    end
    CSV.write(reftablepath, SmallDatasetMaker.DataFrame(SD); append=isfile(reftablepath)) # write .srcfile, .zipfile as relative paths (thus can be abspath! correctly when using `dataset` or `unzip_file` using `package_name` & `dataset_name`)
    # since writeheader=!append, isfile is required
    @info "$(basename(reftablepath)) updated successfully."

end

"""
`compress_save(mod::Module, srcpath; args...)` is equivalent to `compress_save!(mod, SourceData(srcpath))` but returns `SD = SourceData(srcpath)`.

`compress_save` takes the same keyword arguments as `compress_save!`, which returns $returned.

# Example
```julia
using YourDatasets, SmallDatasetMaker
srcfile = "data/raw/Category_A/Dataset_B.csv" # path to the .csv to be compressed.
compress_save(YourDatasets, srcfile; targeting_mod = true)
```
"""
function compress_save(mod::Module, srcpath; args...)
    SD = SourceData(srcpath)
    compress_save!(mod, SD; args...)
    return SD
end
