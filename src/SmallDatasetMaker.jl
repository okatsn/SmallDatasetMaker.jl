module SmallDatasetMaker

# Write your package code here.

# global __datasets = nothing

using OkFiles

using CSV, DataFrames
include("datasets.jl")
export create_empty_table

include("datadir.jl")

using CodecZlib, Dates
import PrettyTables
using OrderedCollections
include("sourcedata.jl")
export SourceData
include("compress.jl")
export compress_save, compress_save!

include("decompress.jl")
export unzip_file


# TODO: create a dataset.csv generator and remove the entire data/doc/datasets.csv


# # Assistant tools
include("tryparse.jl")
export tryparse_summary

include("difftable.jl")
export difftables

include("gc.jl")
export cleantable

end
