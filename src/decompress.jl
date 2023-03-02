"""
`dataset(package_name::AbstractString, dataset_name::AbstractString)` returns a `DataFrame` object unzipped from the last `row` returned by `target_row(package_name, dataset_name)`.
This function mimics the `dataset` function in `RDatasets.jl`.

"""
function dataset(package_name::AbstractString, dataset_name::AbstractString; kwargs...)
    row = target_row(package_name, dataset_name; kwargs...)
    SD = SourceData(row)
    dataset(SD.zipfile)
end

abspathnoticemsg = "If you were intended to load `target_path` under `SWCDatasets` rather than the current directory your working with, you should apply `abspath` that `target_path = SWCDatasets.abspath(target_path)`."

"""
`dataset(target_path)` decompress `target_path` and returns it as a `DataFrame`.

# Notice!
$abspathnoticemsg
"""
function dataset(target_path)
    if !isfile(target_path)
        error("Unable to locate dataset file $target_path")
    end

    df_decomp2 = open(target_path, "r") do io
        uncompressed = IOBuffer(read(GzipDecompressorStream(io)))
        DataFrame(CSV.File(uncompressed))
    end
    return df_decomp2
end

"""
The same as `dataset`, but also save the unzip file.
"""
function unzip_file(package_name::AbstractString, dataset_name::AbstractString; kwargs...)
    row = target_row(package_name, dataset_name; kwargs...)
    SD = SourceData(row)
    decompressed1 = _unzip(SD.zipfile) # load the zipped file in SWCDatasets
    file_decomp = row.RawData # save the unzipped file to path relative to current environment
    df_decomp1 = _save_file(file_decomp, decompressed1)
    return df_decomp1
end

"""
`unzip_file(target_path)` unzip file at `target_path` to current directory preserve its original name.

# Notice!
$abspathnoticemsg
"""
function unzip_file(target_path)
    decompressed1 = _unzip(target_path)
    filename = split(basename(target_path),"."; limit=2) |> first
    file_decomp = filename*".csv"
    _save_file(file_decomp, decompressed1)
end


function _save_file(file_decomp, decompressed1)
    mkpath(dirname(file_decomp))
    if isfile(file_decomp)
        already_exist = load_original(file_decomp)
        @assert isequal(already_exist, decompressed1) "$file_decomp already exists but is different from the current decompressed one. Unzip process aborted."

        @info "File already exists at $(file_decomp) and is identical to the decompressed one"
    else

        open(file_decomp, "w") do io
            write(io, decompressed1)
        end

        @info "File unzipped to $(file_decomp)."
    end
    df_decomp1 = CSV.read(file_decomp, DataFrame)
end

function _unzip(target_path)
    if !isfile(target_path)
        error("Unable to locate dataset file $target_path")
    end

    compressed1 = open(target_path, "r") do io
        read(io)
    end
    decompressed1 = transcode(GzipDecompressor, compressed1)
end
