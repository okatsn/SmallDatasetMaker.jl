module SmallDatasetMaker

# Write your package code here.

global __datasets = nothing

using OkFiles

using CSV,DataFrames
include("datasets.jl")
export create_empty_table

include("datadir.jl")

using CodecZlib,Dates
import PrettyTables
using OrderedCollections
include("compress.jl")
export SourceData, compress_save, compress_save!

include("decompress.jl")

# TODO: create a dataset.csv generator and remove the entire data/doc/datasets.csv

end
