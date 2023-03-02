var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = SmallDatasetMaker","category":"page"},{"location":"#SmallDatasetMaker","page":"Home","title":"SmallDatasetMaker","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for SmallDatasetMaker.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [SmallDatasetMaker]","category":"page"},{"location":"#SmallDatasetMaker.DATASET_ABS_DIR","page":"Home","title":"SmallDatasetMaker.DATASET_ABS_DIR","text":"Absolute directory for package SmallDatasetMaker. Also see abspath.\n\n\n\n\n\n","category":"constant"},{"location":"#SmallDatasetMaker.SourceData-NTuple{4, Any}","page":"Home","title":"SmallDatasetMaker.SourceData","text":"If zipfile not specified, it will be dir_data(package_name, dataset_name*\".gz\").\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.SourceData-NTuple{5, Any}","page":"Home","title":"SmallDatasetMaker.SourceData","text":"If rows, columns not specified, CSV.read(srcfile, DataFrame) will be applied to get the number of rows/columns.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.SourceData-NTuple{7, Any}","page":"Home","title":"SmallDatasetMaker.SourceData","text":"If description not specified, it will be \"\".\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.SourceData-NTuple{8, Any}","page":"Home","title":"SmallDatasetMaker.SourceData","text":"SourceData(srcfile, packagename, datasetname, title, zipfile, rows, columns, description, timestamps)\n\nsrcfile is the path to the source file, the package_name will be the folder that the file resides, the dataset_name will be the name of the data without extension.\n\nIf timestamps not specified, it will be today().\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.SourceData-Tuple{Any, Any, Any}","page":"Home","title":"SmallDatasetMaker.SourceData","text":"If title not specified, it will be \"Data [$dataset_name] of [$package_name]\".\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.SourceData-Tuple{Any}","page":"Home","title":"SmallDatasetMaker.SourceData","text":"If package_name, dataset_name not specified, (package_name, dataset_name) = get_package_dataset_name(srcfile) is applied.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.SourceData-Tuple{DataFrames.DataFrameRow}","page":"Home","title":"SmallDatasetMaker.SourceData","text":"SourceData(row::DataFrameRow) returns\n\nSourceData(\n    abspath(row.RawData),    # srcfile::Union{Missing,String}\n    row.PackageName,         # package_name::String\n    row.Dataset,             # dataset_name::String\n    row.Title,               # title::Union{Missing,String}\n    abspath(row.ZippedData), # zipfile::String\n    row.Rows,                # rows::Int\n    row.Columns,             # columns::Int\n    row.Description,         # description::Union{Missing,String}\n    row.TimeStamp,           # timestamps::TimeType\n    )\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.abspath-Tuple","page":"Home","title":"SmallDatasetMaker.abspath","text":"abspath(args...) = joinpath(DATASET_ABS_DIR[], args...)\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.compress_save!-Tuple{SourceData}","page":"Home","title":"SmallDatasetMaker.compress_save!","text":"compress_save!(SD::SourceData; move_source = true) compress the SD.srcfile, save the zipped one to SD.zipfile, and update the /home/runner/work/SmallDatasetMaker.jl/SmallDatasetMaker.jl/data/doc/datasets.csv. By default, move_source = true that the source file will be moved to dir_raw().\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.compress_save-Tuple{Any}","page":"Home","title":"SmallDatasetMaker.compress_save","text":"compress_save(srcpath) is equivalent to compress_save!(SourceData(srcpath)) but returns SD::SourceData.\n\ncompress_save takes the same keyword arguments as compress_save!.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.dataset-Tuple{AbstractString, AbstractString}","page":"Home","title":"SmallDatasetMaker.dataset","text":"dataset(package_name::AbstractString, dataset_name::AbstractString) returns a DataFrame object unzipped from the last row returned by target_row(package_name, dataset_name). This function mimics the dataset function in RDatasets.jl.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.dataset-Tuple{Any}","page":"Home","title":"SmallDatasetMaker.dataset","text":"dataset(target_path) decompress target_path and returns it as a DataFrame.\n\nNotice!\n\nIf you were intended to load target_path under SmallDatasetMaker rather than the current directory your working with, you should apply abspath that target_path = SmallDatasetMaker.abspath(target_path).\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.dataset_dir-Tuple","page":"Home","title":"SmallDatasetMaker.dataset_dir","text":"Absolute path to the \"data\" of SmallDatasetMaker. See also DATASET_ABS_DIR.\n\nExample\n\n`dataset_dir(\"doc\", \"datasets.csv\")`\n\n# Output\n\"~/.julia/dev/SmallDatasetMaker/data/doc/datasets.csv\"\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.dataset_table-Tuple{}","page":"Home","title":"SmallDatasetMaker.dataset_table","text":"The path to the index table for datasets in SmallDatasetMaker. If SmallDatasetMaker is added using pkg> dev SmallDatasetMaker in other project/environment, dataset_table() returns \"~/.julia/dev/SmallDatasetMaker/src/../data/doc/datasets.csv\".\n\nThe reason for dataset_table to be a function rather than a constant is that I can redefine it in the scope of test. See test/compdecomp.jl.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.datasets-Tuple{}","page":"Home","title":"SmallDatasetMaker.datasets","text":"datasets() returns the table of this dataset, and define the global variable SmallDatasetMaker.__datasets as this table.\n\nSet ; update_table = true to force update SmallDatasetMaker.__datasets with the dataset_table(); this keyword argument is intended to make some tests can work since in test dataset_table() is mutating. # todo: find a better way to deal with it.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.dir_data-Tuple","page":"Home","title":"SmallDatasetMaker.dir_data","text":"Path to the directory for the data.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.dir_raw-Tuple","page":"Home","title":"SmallDatasetMaker.dir_raw","text":"Path to the directory for the backup of the raw data; only for package internal use.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.dir_to_be_converted-Tuple","page":"Home","title":"SmallDatasetMaker.dir_to_be_converted","text":"Path to the directory for the to-be-compressed data; only for package internal use.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.get_package_dataset_name-Tuple{Any}","page":"Home","title":"SmallDatasetMaker.get_package_dataset_name","text":"Given path to the source file, get_package_dataset_name(srcpath) derive package name and dataset name from the srcpath.\n\nExample\n\nsrcpath = joinpath(\"Whatever\", \"RDatasets\", \"iris.csv\")\nSmallDatasetMaker.get_package_dataset_name(srcpath)\n\n# output\n\n(\"RDatasets\", \"iris\")\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.load_original-Tuple{AbstractString}","page":"Home","title":"SmallDatasetMaker.load_original","text":"load_original(path::AbstractString) opens path and return the read data.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.return_compressed-Tuple{AbstractString}","page":"Home","title":"SmallDatasetMaker.return_compressed","text":"return_compressed(path::AbstractString) returned compressed data.\n\nExample\n\ncompressed = return_compressed(\"data/data.csv\")\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.return_compressed-Tuple{Vector{UInt8}}","page":"Home","title":"SmallDatasetMaker.return_compressed","text":"return_compressed(data::Vector{UInt8}) returned compressed data.\n\nExample\n\ndata = load_original(\"data/data.csv\")\ncompressed = return_compressed(data)\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.target_row-Tuple{Any, Any}","page":"Home","title":"SmallDatasetMaker.target_row","text":"target_row returns the latest information in datasets(). Given package_name, dataset_name, target_row(package_name, dataset_name), target_row returns the last row that matches row.PackageName == package_name && row.Dataset == dataset_name\".\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.unzip_file-Tuple{AbstractString, AbstractString}","page":"Home","title":"SmallDatasetMaker.unzip_file","text":"The same as dataset, but also save the unzip file.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.unzip_file-Tuple{Any}","page":"Home","title":"SmallDatasetMaker.unzip_file","text":"unzip_file(target_path) unzip file at target_path to current directory preserve its original name.\n\nNotice!\n\nIf you were intended to load target_path under SmallDatasetMaker rather than the current directory your working with, you should apply abspath that target_path = SmallDatasetMaker.abspath(target_path).\n\n\n\n\n\n","category":"method"}]
}
