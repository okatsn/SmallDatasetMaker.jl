var documenterSearchIndex = {"docs":
[{"location":"assisttools/#Check-your-table","page":"Assistant tools","title":"Check your table","text":"","category":"section"},{"location":"assisttools/","page":"Assistant tools","title":"Assistant tools","text":"Use tryparse_summary.","category":"page"},{"location":"assisttools/","page":"Assistant tools","title":"Assistant tools","text":"tryparse_summary\ndifftables","category":"page"},{"location":"assisttools/#SmallDatasetMaker.tryparse_summary","page":"Assistant tools","title":"SmallDatasetMaker.tryparse_summary","text":"tryparse_summary(v::AbstractVector, typetoparse::Type{<:Any})\n\nExample\n\njulia> tryparse_summary([\"1\", \"2\", \"3.3\", 10, \"NaN\"], Float64) .|> typeof\n5-element Vector{DataType}:\n SmallDatasetMaker.NotException\n SmallDatasetMaker.NotException\n SmallDatasetMaker.NotException\n MethodError\n SmallDatasetMaker.NotException\n\n\n\n\n\ntryparse_summary(df::AbstractDataFrame, typetoparse) returns a \"long\" dataframe with columns :variable_name, :exception_type and :exception_msg.\n\nExample\n\nusing DataFrames\ndf = DataFrame(\n    :name => [\"John\", \"Roe\", \"Mary\", \"Hello\", \"World\"],\n    :salary => [5.372, \"1.1\", \"1\", \"NaN\", \"#value\"],\n    :age => string.([20, 13, 17, 22, 100])\n)\nsummary = tryparse_summary(df, Float64)\ncombine(groupby(summary, [:variable_name, :exception_type, :exception_msg]), nrow)\n\n\n\n\n\n","category":"function"},{"location":"assisttools/#SmallDatasetMaker.difftables","page":"Assistant tools","title":"SmallDatasetMaker.difftables","text":"Given a series of DataFrames, difftables(df0::AbstractDataFrame, dfs::AbstractDataFrame...; ignoring = Cols()) returns report::DataFrame with columns\n\n:nrow: number of rows of each DataFrame.\n:ncol: number of columns of each DataFrame.\n:cols_lack: lack of columns comparing to df0.\n:cols_add:  extra columns comparing to df0.\n\nThis function is useful for update an existing dataset (where the new data might have unidentical column names).\n\n\n\n\n\n","category":"function"},{"location":"README/#Introduction","page":"Introduction","title":"Introduction","text":"","category":"section"},{"location":"README/","page":"Introduction","title":"Introduction","text":"Inspired by RDatasets.jl, SmallDatasetMaker provides tools to create/add/update a julia package of datasets in only a few steps.","category":"page"},{"location":"README/#Getting-started","page":"Introduction","title":"Getting started","text":"","category":"section"},{"location":"README/","page":"Introduction","title":"Introduction","text":"using SmallDatasetMaker","category":"page"},{"location":"README/#.-Create-a-package","page":"Introduction","title":"1. Create a package","text":"","category":"section"},{"location":"README/","page":"Introduction","title":"Introduction","text":"Create a julia package, for example, YourDatasets.jl. For convenience, YourDatasets in this documentation refers an arbitrary package of datasets working with SmallDatasetMaker herein after.","category":"page"},{"location":"README/","page":"Introduction","title":"Introduction","text":"See PkgTemplates and Pkg.jl/Creating Packages about how to create a julia package.","category":"page"},{"location":"README/","page":"Introduction","title":"Introduction","text":"SmallDatasetMaker should be added to the Project.toml of YourDatasets:","category":"page"},{"location":"README/","page":"Introduction","title":"Introduction","text":"(YourDatasets) pkg> add SmallDatasetMaker","category":"page"},{"location":"README/#.-Convert-the-raw-data-to-a-dataset","page":"Introduction","title":"2. Convert the raw data to a dataset","text":"","category":"section"},{"location":"README/","page":"Introduction","title":"Introduction","text":"note: Note\nActivate the environment YourDatasets and using SmallDatasetMaker first!","category":"page"},{"location":"README/","page":"Introduction","title":"Introduction","text":"Make your dataset to be compressed a csv file.\nDefine the SourceData object with the srcpath to be the path to this csv file.\nCall compress_save! or compress_save.","category":"page"},{"location":"README/","page":"Introduction","title":"Introduction","text":"SourceData\ncompress_save!\ncompress_save","category":"page"},{"location":"README/#SmallDatasetMaker.SourceData","page":"Introduction","title":"SmallDatasetMaker.SourceData","text":"SourceData(srcfile, package_name, dataset_name, title, zipfile, rows, columns, description, timestamps)\n\nsrcfile is the path to the source file, the package_name will be the folder that the file resides, the dataset_name will be the name of the data without extension.\n\nIf timestamps not specified, it will be today().\n\n\n\n\n\nIf description not specified, it will be \"\".\n\n\n\n\n\nIf rows, columns not specified, CSV.read(srcfile, DataFrame) will be applied to get the number of rows/columns.\n\n\n\n\n\nIf zipfile not specified, it will be dir_data(package_name, dataset_name*\".gz\").\n\n\n\n\n\nIf title not specified, it will be \"Data [$dataset_name] of [$package_name]\".\n\n\n\n\n\nIf package_name, dataset_name not specified, (package_name, dataset_name) = get_package_dataset_name(srcfile) is applied.\n\nExample\n\nusing SmallDatasetMaker\nsrcfile = \"data/raw/Category_A/Dataset_B.csv\" # path to the .csv to be compressed.\nSD = SourceData(srcfile)\n\n\n\n\n\nSourceData(mod::Module, row::DataFrameRow) applies create an SourceData objects from a row of a DataFrame (i.e., dataset_table(mod)), with abspath! applied.\n\nThis is for loading data according to dataset_table; thus, paths should be referred to that in mod instead of being relative to the current directory.\n\n\n\n\n\n","category":"type"},{"location":"README/#SmallDatasetMaker.compress_save!","page":"Introduction","title":"SmallDatasetMaker.compress_save!","text":"compress_save!(mod::Module, SD::SourceData; move_source = true) compress the SD.srcfile, save the zipped one to SD.zipfile, and update the dataset_table(mod). By default, move_source = true that the source file will be moved to dir_raw().\n\ncompress_save! returns SD::SourceData of relative paths to DATASET_ABS_DIR(mod)[], where relpath! is applied that paths SD as well as dataset_table(mod) are modified to be relative.\n\nExample\n\nusing YourDatasets, SmallDatasetMaker\ncompress_save!(YourDatasets, SD)\n\nThis do the followings:\n\nCreate zipped files under data/ of package YourDatasets in development.\nMove the source file SD.srcfile (i.e., the raw .csv data) to dir_raw(YourDatasets, ...) by default.\nAdd a new line to SmallDatasetMaker.dataset_table(YourDatasets) (update data/doc/datasets.csv of YourDatasets).\n\nSee also SourceData, compress_save.\n\n\n\n\n\n","category":"function"},{"location":"README/#SmallDatasetMaker.compress_save","page":"Introduction","title":"SmallDatasetMaker.compress_save","text":"compress_save(mod::Module, srcpath; args...) is equivalent to compress_save!(mod, SourceData(srcpath)) but returns SD = SourceData(srcpath).\n\ncompress_save takes the same keyword arguments as compress_save!, which returns SD::SourceData of relative paths to DATASET_ABS_DIR(mod)[].\n\nExample\n\nusing YourDatasets, SmallDatasetMaker\nsrcfile = \"data/raw/Category_A/Dataset_B.csv\" # path to the .csv to be compressed.\ncompress_save(YourDatasets, srcfile)\n\n\n\n\n\n","category":"function"},{"location":"README/#.-Add-methods-dataset-and-datasets","page":"Introduction","title":"3. Add methods dataset and datasets","text":"","category":"section"},{"location":"README/","page":"Introduction","title":"Introduction","text":"using SmallDatasetMaker in the module scope of YourDatasets\n(Optional) New methods for dataset and datasets.","category":"page"},{"location":"README/#Example","page":"Introduction","title":"Example","text":"","category":"section"},{"location":"README/","page":"Introduction","title":"Introduction","text":"In src/YourDatasets.jl:","category":"page"},{"location":"README/","page":"Introduction","title":"Introduction","text":"\nmodule YourDatasets\n\n    using SmallDatasetMaker\n   # (required) See also `SmallDatasetMaker.datasets`.\n\n    function YourDatasets.dataset(package_name, dataset_name)\n        SmallDatasetMaker.dataset(YourDatasets,package_name, dataset_name)\n    end \n    # (optional but recommended) \n    # To allow direct use of `dataset` without `SmallDatasetMaker`.\n\n    YourDatasets.datasets() = SmallDatasetMaker.datasets(YourDatasets) \n    # (optional but recommended) To allow the direct use of `YourDatasets.datasets()`\nend\n","category":"page"},{"location":"README/#.-Use-YourDatasets","page":"Introduction","title":"4. Use YourDatasets","text":"","category":"section"},{"location":"README/","page":"Introduction","title":"Introduction","text":"In the case new methods YourDatasets.dataset and YourDatasets.datasets has been created:","category":"page"},{"location":"README/","page":"Introduction","title":"Introduction","text":"using YourDatasets\nYourDatasets.datasets() # a DataFrame for all availabe packages and datasets\ndf = YourDatasets.dataset(\"LHVRSHIVA\", \"SHIVA\") # load dataset \"SHIVA\" in package \"LHVRSHIVA\" as a DataFrame","category":"page"},{"location":"README/","page":"Introduction","title":"Introduction","text":"In the case new methods YourDatasets.dataset and YourDatasets.datasets() has NOT been created:","category":"page"},{"location":"README/","page":"Introduction","title":"Introduction","text":"using YourDatasets, SmallDatasetMaker\nSmallDatasetMaker.datasets(YourDatasets)\ndf = SmallDatasetMaker.dataset(YourDatasets, \"LHVRSHIVA\", \"SHIVA\")","category":"page"},{"location":"README/","page":"Introduction","title":"Introduction","text":"See also Example.","category":"page"},{"location":"README/#Best-practice/Hints","page":"Introduction","title":"Best practice/Hints","text":"","category":"section"},{"location":"README/#Keep-the-default-branch-clean-without-raw-data","page":"Introduction","title":"Keep the default branch clean without raw data","text":"","category":"section"},{"location":"README/","page":"Introduction","title":"Introduction","text":"Commit and push only the compressed .gz files and the updated data/doc/datasets.csv\nYou may work on an alternative branch, e.g. new-dataset-from-raw, and use git merge --no-ff new-dataset-from-raw to your default branch and manually un-stage all artifacts.","category":"page"},{"location":"README/","page":"Introduction","title":"Introduction","text":"note: \nNoted that if the default branch isn't clean, pkg> add YourDatasets will take extra unnecessary disk space.\nYou may simply follow the hygiene of \nalways place raw data in data/raw/ and \nadd data/raw/ in .gitignore","category":"page"},{"location":"README/#Optional","page":"Introduction","title":"Optional","text":"","category":"section"},{"location":"README/#Test","page":"Introduction","title":"Test","text":"","category":"section"},{"location":"README/","page":"Introduction","title":"Introduction","text":"You may also optionally have the following tests in YourDatasets:","category":"page"},{"location":"README/","page":"Introduction","title":"Introduction","text":"Test if the table to the list of YourDatasets is fine:","category":"page"},{"location":"README/","page":"Introduction","title":"Introduction","text":"@testset \"Test if datasets() works\" begin\n    using DataFrames\n    df = YourDatasets.datasets()\n    @test isa(df, DataFrame)\n    @test isa(YourDatasets.__datasets, DataFrame)\nend\n","category":"page"},{"location":"README/","page":"Introduction","title":"Introduction","text":"@testset \"Test if ALL datasets can be successfully loaded.\" begin\n    using DataFrames\n    for lastrow in eachrow(YourDatasets.__datasets)\n        pkgnm = lastrow.PackageName\n        datnm = lastrow.Dataset\n        df = YourDatasets.dataset(pkgnm, datnm)\n        @info \"$pkgnm/$datnm goes through `PrepareTableDefault` without error.\"\n        @test lastrow.Columns == ncol(df)\n        @test lastrow.Rows == nrow(df)\n    end\n    @test true\nend","category":"page"},{"location":"README/#See-also","page":"Introduction","title":"See also","text":"","category":"section"},{"location":"README/#How-dataset-and-datasets-work","page":"Introduction","title":"How dataset and datasets work","text":"","category":"section"},{"location":"README/","page":"Introduction","title":"Introduction","text":"See also","category":"page"},{"location":"README/","page":"Introduction","title":"Introduction","text":"SmallDatasetMaker.datasets\nSmallDatasetMaker.dataset","category":"page"},{"location":"README/#SmallDatasetMaker.datasets","page":"Introduction","title":"SmallDatasetMaker.datasets","text":"datasets(mod::Module) reads the table from dataset_table(mod), and set __datasets::DataFrame to be the const variable in the scope of mod (i.e., mod.__datasets show the list of packages and datasets).\n\nIf there is no using SmallDatasetMaker in the module $mod ... end, it will fail since it is executed at the scope of mod.\n\n\n\n\n\n","category":"function"},{"location":"README/#SmallDatasetMaker.dataset","page":"Introduction","title":"SmallDatasetMaker.dataset","text":"dataset(package_name::AbstractString, dataset_name::AbstractString) returns a DataFrame object unzipped from the last row returned by target_row(mod, package_name, dataset_name). This function mimics the dataset function in RDatasets.jl.\n\n\n\n\n\ndataset(target_path) decompress target_path and returns it as a DataFrame.\n\nNotice!\n\nIf you were intended to load target_path under SmallDatasetMaker or anyother package rather than the current directory you are working with, you should apply abspath(args::String...) or abspath(ACertainImportedPackage, args::String...) that target_path = SmallDatasetMaker.abspath(...).\n\n\n\n\n\n","category":"function"},{"location":"README/#How-package_name-and-dataset_name-is-automatically-determined:","page":"Introduction","title":"How package_name and dataset_name is automatically determined:","text":"","category":"section"},{"location":"README/","page":"Introduction","title":"Introduction","text":"SD = SourceData(\"data/raw/Hello/world.csv\");\n(SD.package_name, SD.dataset_name)","category":"page"},{"location":"README/","page":"Introduction","title":"Introduction","text":"SmallDatasetMaker.get_package_dataset_name(\"data/raw/Hello/world.csv\") #hide","category":"page"},{"location":"README/","page":"Introduction","title":"Introduction","text":"See also","category":"page"},{"location":"README/","page":"Introduction","title":"Introduction","text":"SmallDatasetMaker.get_package_dataset_name","category":"page"},{"location":"README/#SmallDatasetMaker.get_package_dataset_name","page":"Introduction","title":"SmallDatasetMaker.get_package_dataset_name","text":"Given path to the source file, get_package_dataset_name(srcpath) derive package name and dataset name from the srcpath.\n\nExample\n\nsrcpath = joinpath(\"Whatever\", \"RDatasets\", \"iris.csv\")\nSmallDatasetMaker.get_package_dataset_name(srcpath)\n\n# output\n\n(\"RDatasets\", \"iris\")\n\n\n\n\n\n","category":"function"},{"location":"README/#Where-is-the-raw-data","page":"Introduction","title":"Where is the raw data","text":"","category":"section"},{"location":"README/","page":"Introduction","title":"Introduction","text":"SmallDatasetMaker.dir_raw","category":"page"},{"location":"README/#SmallDatasetMaker.dir_raw","page":"Introduction","title":"SmallDatasetMaker.dir_raw","text":"Path to the directory \"data/raw/\" of module mod; the default directory for the raw data.\n\n\n\n\n\n","category":"function"},{"location":"README/#Difference-between-the-usage-of-YourDatasets-and-RDatasets","page":"Introduction","title":"Difference between the usage of YourDatasets and RDatasets","text":"","category":"section"},{"location":"README/","page":"Introduction","title":"Introduction","text":"Here are the highlights of differences between the usage of YourDatasets (created by SmallDatasetMaker) and RDatasets:","category":"page"},{"location":"README/","page":"Introduction","title":"Introduction","text":"For RDatasets, RDatasets.__datasets is a global variable; whereas YourDatasets.__datasets is a const variable.","category":"page"},{"location":"","page":"Index","title":"Index","text":"CurrentModule = SmallDatasetMaker","category":"page"},{"location":"#SmallDatasetMaker","page":"Index","title":"SmallDatasetMaker","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"Documentation for SmallDatasetMaker.","category":"page"},{"location":"","page":"Index","title":"Index","text":"","category":"page"},{"location":"","page":"Index","title":"Index","text":"Modules = [SmallDatasetMaker]","category":"page"},{"location":"#SmallDatasetMaker.column_field_dictionary","page":"Index","title":"SmallDatasetMaker.column_field_dictionary","text":"column_field_dictionary follows the order of the field of Source data.\n\n\n\n\n\n","category":"constant"},{"location":"#SmallDatasetMaker.field_column_dictionary","page":"Index","title":"SmallDatasetMaker.field_column_dictionary","text":"field_column_dictionary follows the order of the field of Source data.\n\n\n\n\n\n","category":"constant"},{"location":"#SmallDatasetMaker.ordered_columns","page":"Index","title":"SmallDatasetMaker.ordered_columns","text":"The order for dataset_table().\n\n\n\n\n\n","category":"constant"},{"location":"#DataFrames.DataFrame-Tuple{SourceData}","page":"Index","title":"DataFrames.DataFrame","text":"Construct a DataFrame following the order of ordered_columns.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.SourceData-NTuple{4, Any}","page":"Index","title":"SmallDatasetMaker.SourceData","text":"If zipfile not specified, it will be dir_data(package_name, dataset_name*\".gz\").\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.SourceData-NTuple{5, Any}","page":"Index","title":"SmallDatasetMaker.SourceData","text":"If rows, columns not specified, CSV.read(srcfile, DataFrame) will be applied to get the number of rows/columns.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.SourceData-NTuple{7, Any}","page":"Index","title":"SmallDatasetMaker.SourceData","text":"If description not specified, it will be \"\".\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.SourceData-NTuple{8, Any}","page":"Index","title":"SmallDatasetMaker.SourceData","text":"SourceData(srcfile, package_name, dataset_name, title, zipfile, rows, columns, description, timestamps)\n\nsrcfile is the path to the source file, the package_name will be the folder that the file resides, the dataset_name will be the name of the data without extension.\n\nIf timestamps not specified, it will be today().\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.SourceData-Tuple{Any, Any, Any}","page":"Index","title":"SmallDatasetMaker.SourceData","text":"If title not specified, it will be \"Data [$dataset_name] of [$package_name]\".\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.SourceData-Tuple{Any}","page":"Index","title":"SmallDatasetMaker.SourceData","text":"If package_name, dataset_name not specified, (package_name, dataset_name) = get_package_dataset_name(srcfile) is applied.\n\nExample\n\nusing SmallDatasetMaker\nsrcfile = \"data/raw/Category_A/Dataset_B.csv\" # path to the .csv to be compressed.\nSD = SourceData(srcfile)\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.SourceData-Tuple{Module, DataFrames.DataFrameRow}","page":"Index","title":"SmallDatasetMaker.SourceData","text":"SourceData(mod::Module, row::DataFrameRow) applies create an SourceData objects from a row of a DataFrame (i.e., dataset_table(mod)), with abspath! applied.\n\nThis is for loading data according to dataset_table; thus, paths should be referred to that in mod instead of being relative to the current directory.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.DATASET_ABS_DIR-Tuple{Module}","page":"Index","title":"SmallDatasetMaker.DATASET_ABS_DIR","text":"DATASET_ABS_DIR(mod::Module) returns the absolute directory for package mod.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.abspath!-Tuple{SourceData, Module}","page":"Index","title":"SmallDatasetMaker.abspath!","text":"abspath!(SD::SourceData, mod::Module) makes all paths in SD to be absolute with the starting directory DATASET_ABS_DIR.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.abspath-Tuple{Module, Vararg{Any}}","page":"Index","title":"SmallDatasetMaker.abspath","text":"abspath(mod::Module, args...) = joinpath(DATASET_ABS_DIR(mod)[], args...).\n\nWARNING: DO NOT EXPORT THIS FUNCTION\n\nthis function has the same name of abspath in FilePathsBase and Base.Filesystem.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.compress_save!-Tuple{Module, SourceData}","page":"Index","title":"SmallDatasetMaker.compress_save!","text":"compress_save!(mod::Module, SD::SourceData; move_source = true) compress the SD.srcfile, save the zipped one to SD.zipfile, and update the dataset_table(mod). By default, move_source = true that the source file will be moved to dir_raw().\n\ncompress_save! returns SD::SourceData of relative paths to DATASET_ABS_DIR(mod)[], where relpath! is applied that paths SD as well as dataset_table(mod) are modified to be relative.\n\nExample\n\nusing YourDatasets, SmallDatasetMaker\ncompress_save!(YourDatasets, SD)\n\nThis do the followings:\n\nCreate zipped files under data/ of package YourDatasets in development.\nMove the source file SD.srcfile (i.e., the raw .csv data) to dir_raw(YourDatasets, ...) by default.\nAdd a new line to SmallDatasetMaker.dataset_table(YourDatasets) (update data/doc/datasets.csv of YourDatasets).\n\nSee also SourceData, compress_save.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.compress_save-Tuple{Module, Any}","page":"Index","title":"SmallDatasetMaker.compress_save","text":"compress_save(mod::Module, srcpath; args...) is equivalent to compress_save!(mod, SourceData(srcpath)) but returns SD = SourceData(srcpath).\n\ncompress_save takes the same keyword arguments as compress_save!, which returns SD::SourceData of relative paths to DATASET_ABS_DIR(mod)[].\n\nExample\n\nusing YourDatasets, SmallDatasetMaker\nsrcfile = \"data/raw/Category_A/Dataset_B.csv\" # path to the .csv to be compressed.\ncompress_save(YourDatasets, srcfile)\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.create_empty_table-Tuple","page":"Index","title":"SmallDatasetMaker.create_empty_table","text":"Initiate referencing table at dataset_table(args...). It takes exactly the same arguments of dataset_table.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.dataset-Tuple{Any}","page":"Index","title":"SmallDatasetMaker.dataset","text":"dataset(target_path) decompress target_path and returns it as a DataFrame.\n\nNotice!\n\nIf you were intended to load target_path under SmallDatasetMaker or anyother package rather than the current directory you are working with, you should apply abspath(args::String...) or abspath(ACertainImportedPackage, args::String...) that target_path = SmallDatasetMaker.abspath(...).\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.dataset-Tuple{Module, AbstractString, AbstractString}","page":"Index","title":"SmallDatasetMaker.dataset","text":"dataset(package_name::AbstractString, dataset_name::AbstractString) returns a DataFrame object unzipped from the last row returned by target_row(mod, package_name, dataset_name). This function mimics the dataset function in RDatasets.jl.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.dataset_dir-Tuple{Module, Vararg{String}}","page":"Index","title":"SmallDatasetMaker.dataset_dir","text":"dataset_dir(mod::Module, args::String...) returns the absolute dataset path referencing mod.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.dataset_table-Tuple{Module}","page":"Index","title":"SmallDatasetMaker.dataset_table","text":"dataset_table(mod::Module) = joinpath(DATASET_ABS_DIR(mod)[],\"data\", \"doc\", \"datasets.csv\")\n\nThe reason for dataset_table to be a function rather than a constant is that I can redefine it in the scope of test. See test/compdecomp.jl.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.datasets-Tuple{Module}","page":"Index","title":"SmallDatasetMaker.datasets","text":"datasets(mod::Module) reads the table from dataset_table(mod), and set __datasets::DataFrame to be the const variable in the scope of mod (i.e., mod.__datasets show the list of packages and datasets).\n\nIf there is no using SmallDatasetMaker in the module $mod ... end, it will fail since it is executed at the scope of mod.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.difftables-Tuple{DataFrames.AbstractDataFrame, Vararg{DataFrames.AbstractDataFrame}}","page":"Index","title":"SmallDatasetMaker.difftables","text":"Given a series of DataFrames, difftables(df0::AbstractDataFrame, dfs::AbstractDataFrame...; ignoring = Cols()) returns report::DataFrame with columns\n\n:nrow: number of rows of each DataFrame.\n:ncol: number of columns of each DataFrame.\n:cols_lack: lack of columns comparing to df0.\n:cols_add:  extra columns comparing to df0.\n\nThis function is useful for update an existing dataset (where the new data might have unidentical column names).\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.dir_data-Tuple","page":"Index","title":"SmallDatasetMaker.dir_data","text":"Relative path to the directory of data; this is called by SourceData.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.dir_data-Tuple{Module, Vararg{Any}}","page":"Index","title":"SmallDatasetMaker.dir_data","text":"Absolute path to the directory of data.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.dir_raw-Tuple{Module, Vararg{Any}}","page":"Index","title":"SmallDatasetMaker.dir_raw","text":"Path to the directory \"data/raw/\" of module mod; the default directory for the raw data.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.get_package_dataset_name-Tuple{Any}","page":"Index","title":"SmallDatasetMaker.get_package_dataset_name","text":"Given path to the source file, get_package_dataset_name(srcpath) derive package name and dataset name from the srcpath.\n\nExample\n\nsrcpath = joinpath(\"Whatever\", \"RDatasets\", \"iris.csv\")\nSmallDatasetMaker.get_package_dataset_name(srcpath)\n\n# output\n\n(\"RDatasets\", \"iris\")\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.load_original-Tuple{AbstractString}","page":"Index","title":"SmallDatasetMaker.load_original","text":"load_original(path::AbstractString) opens path and return the read data.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.relpath!-Tuple{SourceData, Module}","page":"Index","title":"SmallDatasetMaker.relpath!","text":"relpath!(SD::SourceData, mod::Module) makes all paths in SD to be relative path to DATASET_ABS_DIR.\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.return_compressed-Tuple{AbstractString}","page":"Index","title":"SmallDatasetMaker.return_compressed","text":"return_compressed(path::AbstractString) returned compressed data.\n\nExample\n\ncompressed = return_compressed(\"data/data.csv\")\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.return_compressed-Tuple{Vector{UInt8}}","page":"Index","title":"SmallDatasetMaker.return_compressed","text":"return_compressed(data::Vector{UInt8}) returned compressed data.\n\nExample\n\ndata = load_original(\"data/data.csv\")\ncompressed = return_compressed(data)\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.target_row-Tuple{Module, Any, Any}","page":"Index","title":"SmallDatasetMaker.target_row","text":"target_row returns the latest information in datasets(mod::Module). Given package_name, dataset_name, target_row(mod, package_name, dataset_name), target_row returns the last row that matches row.PackageName == package_name && row.Dataset == dataset_name\".\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.tryparse_summary-Tuple{AbstractVector, Any}","page":"Index","title":"SmallDatasetMaker.tryparse_summary","text":"tryparse_summary(v::AbstractVector, typetoparse::Type{<:Any})\n\nExample\n\njulia> tryparse_summary([\"1\", \"2\", \"3.3\", 10, \"NaN\"], Float64) .|> typeof\n5-element Vector{DataType}:\n SmallDatasetMaker.NotException\n SmallDatasetMaker.NotException\n SmallDatasetMaker.NotException\n MethodError\n SmallDatasetMaker.NotException\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.tryparse_summary-Tuple{DataFrames.AbstractDataFrame, Any}","page":"Index","title":"SmallDatasetMaker.tryparse_summary","text":"tryparse_summary(df::AbstractDataFrame, typetoparse) returns a \"long\" dataframe with columns :variable_name, :exception_type and :exception_msg.\n\nExample\n\nusing DataFrames\ndf = DataFrame(\n    :name => [\"John\", \"Roe\", \"Mary\", \"Hello\", \"World\"],\n    :salary => [5.372, \"1.1\", \"1\", \"NaN\", \"#value\"],\n    :age => string.([20, 13, 17, 22, 100])\n)\nsummary = tryparse_summary(df, Float64)\ncombine(groupby(summary, [:variable_name, :exception_type, :exception_msg]), nrow)\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.unzip_file-Tuple{Any}","page":"Index","title":"SmallDatasetMaker.unzip_file","text":"unzip_file(target_path) unzip file at target_path to current directory preserve its original name.\n\nNotice!\n\nIf you were intended to load target_path under SmallDatasetMaker or anyother package rather than the current directory you are working with, you should apply abspath(args::String...) or abspath(ACertainImportedPackage, args::String...) that target_path = SmallDatasetMaker.abspath(...).\n\n\n\n\n\n","category":"method"},{"location":"#SmallDatasetMaker.unzip_file-Tuple{Module, AbstractString, AbstractString}","page":"Index","title":"SmallDatasetMaker.unzip_file","text":"The same as dataset, but also save the unzip file.\n\n\n\n\n\n","category":"method"},{"location":"example/#Example","page":"Example","title":"Example","text":"","category":"section"},{"location":"example/#List-available-datasets","page":"Example","title":"List available datasets","text":"","category":"section"},{"location":"example/","page":"Example","title":"Example","text":"using SWCExampleDatasets\nSWCExampleDatasets.datasets()","category":"page"},{"location":"example/","page":"Example","title":"Example","text":"which is equivalent to:","category":"page"},{"location":"example/","page":"Example","title":"Example","text":"using SWCExampleDatasets, SmallDatasetMaker\nSmallDatasetMaker.datasets(SWCExampleDatasets)","category":"page"},{"location":"example/","page":"Example","title":"Example","text":"Or, alternatively, ","category":"page"},{"location":"example/","page":"Example","title":"Example","text":"SWCExampleDatasets.__datasets","category":"page"},{"location":"example/#Load-a-specific-dataset","page":"Example","title":"Load a specific dataset","text":"","category":"section"},{"location":"example/","page":"Example","title":"Example","text":"df = SWCExampleDatasets.dataset(\"NCUWiseLab\", \"ARI_G2F820_example\")\ndf[1:5, :]","category":"page"},{"location":"example/","page":"Example","title":"Example","text":"which is equivalent to:","category":"page"},{"location":"example/","page":"Example","title":"Example","text":"df = SmallDatasetMaker.dataset(SWCExampleDatasets, \"NCUWiseLab\", \"ARI_G2F820_example\")\ndf[1:5, :]","category":"page"}]
}
