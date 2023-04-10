module SmallDatasetMaker

# Write your package code here.

# global __datasets = nothing

using OkFiles

using CSV,DataFrames
include("datasets.jl")
export create_empty_table, datasets

include("datadir.jl")

using CodecZlib,Dates
import PrettyTables
using OrderedCollections
include("sourcedata.jl")
export SourceData
include("compress.jl")
export compress_save, compress_save!

include("decompress.jl")
export dataset, unzip_file

include("tryparse.jl")
export tryparse_summary

# TODO: create a dataset.csv generator and remove the entire data/doc/datasets.csv

end
