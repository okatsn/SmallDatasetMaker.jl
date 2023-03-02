module SmallDatasetMaker

# Write your package code here.

global __datasets = nothing

using OkFiles

using CSV,DataFrames
include("datasets.jl")

include("datadir.jl")

using CodecZlib,Dates
import PrettyTables
include("compress.jl")
export SourceData, compress_save, compress_save!


include("decompress.jl")

end
