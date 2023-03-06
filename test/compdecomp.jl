using CodecZlib,CSV,DataFrames,RDatasets,Dates

SmallDatasetMaker.dataset_table() = "datasets_for_test.csv"

SmallDatasetMaker.today() = Date(2023,2,15) # To make the content in datasets_for_test.csv unchanged after test.

# Extending methods for test

SmallDatasetMaker.unzip_file(package_name::AbstractString, dataset_name::AbstractString; kwargs...) = unzip_file(SmallDatasetMaker, package_name::AbstractString, dataset_name::AbstractString; kwargs...)

SmallDatasetMaker.dataset(package_name::AbstractString, dataset_name::AbstractString; kwargs...) = dataset(SmallDatasetMaker,package_name::AbstractString, dataset_name::AbstractString; kwargs...)

create_empty_table()
iris = RDatasets.dataset("datasets", "iris")

@testset "Field-Column test" begin
    # field_column_dictionary follows the order of the field of Source data.
    @test isequal.(fieldnames(SmallDatasetMaker.SourceData), keys(SmallDatasetMaker.field_column_dictionary)) |> all
end

@testset "Source-Target paths" begin

    srcdir = SmallDatasetMaker.dir_data("temp")
    targetdir = SmallDatasetMaker.dir_data()
    rawdir = SmallDatasetMaker.dir_data("raw")

    mkpath.([srcdir, targetdir, rawdir])
    srcfile = joinpath(srcdir, "iris.csv")
    CSV.write(srcfile, iris)

    package_name = "MJ"
    dataset_name = "IRIS"
    SD = SmallDatasetMaker.SourceData(srcfile, package_name, dataset_name)
    show(SD) # also test `show`

    @test isequal.(names(SmallDatasetMaker.DataFrame(SD)), string.(SmallDatasetMaker.ordered_columns)) |> all # DataFrame created from SourceData should in the correct order as ordered_columns # KEYNOTE: This is not necessary but just test if it is consistent with docstring since appending DataFrame is insensitive to column order.

    SmallDatasetMaker.compress_save!(SD) ##KEYNOTE: test the main method
    @test isfile(SD.zipfile) || "Target file ($(SD.zipfile)) unexported"

    df_decomp2 = SmallDatasetMaker.dataset(SD.zipfile)
    df_decomp1 = SmallDatasetMaker.unzip_file(SD.zipfile)

    @test isequal(df_decomp1, df_decomp2)

    @test isfile(SmallDatasetMaker.dir_data(package_name, dataset_name*".gz")) || "Target file not exists or named correctly"

    @test !isfile(srcfile) || "srcfile should be moved to dir_raw()"
    @test isfile(SD.srcfile) || "SD.srcfile should be updated and the file should exists"
    @test isfile(SmallDatasetMaker.dir_raw(basename(SD.srcfile))) || "srcfile should be moved to dir_raw()"

    rm("IRIS.csv")
    rm("data"; recursive = true)
end


@testset "Compress and Decompress" begin


    srcdir = SmallDatasetMaker.dir_data("RDatasets")
    mkpath(srcdir)
    srcfile = joinpath(srcdir, "iris.csv")
    CSV.write(srcfile, iris)

    original = SmallDatasetMaker.load_original(srcfile)

    # Test different methods for `return_compressed`
    compressed1 = SmallDatasetMaker.return_compressed(original)
    compressed2 = SmallDatasetMaker.return_compressed(srcfile)

    @test isequal(compressed1, compressed2)

    decompressed1 = transcode(CodecZlib.GzipDecompressor, compressed1)
    @test isequal(decompressed1, original)

    # Test compress_save
    SD = SmallDatasetMaker.compress_save(srcfile; move_source=true) # KEYNOTE: test the alternative method
    target_path = SD.zipfile



    df_decomp2 = SmallDatasetMaker.dataset(target_path)
    df_decomp1 = SmallDatasetMaker.unzip_file(target_path)
    rm(basename(srcfile)) # By default iris.csv is uzipped to pwd
    df_decomp0 = CSV.read(SD.srcfile, DataFrame)


    @test isequal(df_decomp1, df_decomp0)
    @test isequal(df_decomp2, df_decomp0)


    package_name1, dataset_name1 = SmallDatasetMaker.get_package_dataset_name(srcfile)
    package_name2, dataset_name2 = SmallDatasetMaker.get_package_dataset_name(target_path)
    @test isequal(package_name1,package_name2)
    @test isequal(dataset_name1,dataset_name2)

    @info "`srcfile`: $srcfile"
    @info "`target_path`: $target_path"
    @info "Test if the two files exists:"
    @test !isfile(srcfile) # should be moved
    @test isfile(SD.srcfile) # to here!
    @test isfile(target_path)

    rm("data"; recursive = true)
end

rm(SmallDatasetMaker.dataset_table())