using CodecZlib,CSV,DataFrames,RDatasets,Dates


SmallDatasetMaker.today() = Date(2023,2,15) # To make the content in datasets_for_test.csv unchanged after test.

# Extending methods for test



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
    target_path = SmallDatasetMaker.abspath(SD.zipfile)
    @test isfile(target_path) || "Target file ($(target_path)) unexported"

    df_decomp2 = SmallDatasetMaker.dataset(target_path)
    df_decomp1 = SmallDatasetMaker.unzip_file(target_path)

    @test isequal(df_decomp1, df_decomp2)

    @test isfile(SmallDatasetMaker.dir_data(package_name, dataset_name*".gz")) || "Target file not exists or named correctly"

    @test !isfile(srcfile) || "srcfile should be moved to dir_raw"
    source_file_moved = SmallDatasetMaker.abspath(SD.srcfile)
    @test isfile(source_file_moved) || "SD.srcfile should be updated and the file should exists"

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
    # SD0 = SourceData(srcfile)

    # KEYNOTE: test the alternative method
    SD = SmallDatasetMaker.compress_save(srcfile; move_source=true) # save to SmallDatasetMaker/data/...
    target_path = SmallDatasetMaker.abspath(SD.zipfile)



    df_decomp2 = SmallDatasetMaker.dataset(target_path)
    df_decomp1 = SmallDatasetMaker.unzip_file(target_path)
    rm(basename(srcfile)) # By default iris.csv is uzipped to pwd


    source_file_moved = SmallDatasetMaker.abspath(SD.srcfile)
    df_decomp0 = CSV.read(source_file_moved, DataFrame)


    @test isequal(df_decomp1, df_decomp0)
    @test isequal(df_decomp2, df_decomp0)


    package_name1, dataset_name1 = SmallDatasetMaker.get_package_dataset_name(srcfile)
    package_name2, dataset_name2 = SmallDatasetMaker.get_package_dataset_name(target_path)
    @test isequal(package_name1,package_name2)
    @test isequal(dataset_name1,dataset_name2)

    @info "`srcfile`: $srcfile"
    @info "`source_file_moved`: $source_file_moved"
    @info "`target_path`: $target_path"
    @info "`SD.zipfile`: $(SD.zipfile)"
    @info "Test if the two files exists:"

    @test !isfile(srcfile) # should be moved
    @test !isfile(SD.srcfile) # should no longer here in test's scope
    @test isfile(source_file_moved) # to here!
    @test isfile(target_path)
    @test !isfile(SD.zipfile) # zipped file is not relative to the test directory

    rm(SmallDatasetMaker.dataset_dir(); recursive = true)
end


# TODO: test relative paths:
# - compress_save! makes paths in SD relative
# - SourceData(mod, ::DataFrameRow) makes paths absolute
# - SourceData(mod, ::NotDataFrameRow) makes paths relative to mod
