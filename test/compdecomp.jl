using CodecZlib,CSV,DataFrames,RDatasets,Dates

SWCDatasets.dataset_table() = "datasets_for_test.csv"

SWCDatasets.today() = Date(2023,2,15) # To make the content in datasets_for_test.csv unchanged after test.

DataFrame(
    :PackageName => String[],
    :Dataset => String[],
    :Title => String[],
    :Rows => String[],
    :Columns => String[],
    :Description => String[],
    :TimeStamp => String[],
    :RawData => String[],
    :ZippedData => String[],
) |> df -> CSV.write(SWCDatasets.dataset_table(), df)

iris = RDatasets.dataset("datasets", "iris")

@testset "Source-Target paths" begin

    srcdir = SWCDatasets.dir_data("temp")
    targetdir = SWCDatasets.dir_data()
    rawdir = SWCDatasets.dir_data("raw")

    mkpath.([srcdir, targetdir, rawdir])
    srcfile = joinpath(srcdir, "iris.csv")
    CSV.write(srcfile, iris)

    package_name = "MJ"
    dataset_name = "IRIS"
    SD = SWCDatasets.SourceData(srcfile, package_name, dataset_name)
    show(SD) # also test `show`

    SWCDatasets.compress_save!(SD) ##KEYNOTE: test the main method
    @test isfile(SD.zipfile) || "Target file ($(SD.zipfile)) unexported"

    df_decomp2 = SWCDatasets.dataset(SD.zipfile)
    df_decomp1 = SWCDatasets.unzip_file(SD.zipfile)

    @test isequal(df_decomp1, df_decomp2)

    @test isfile(SWCDatasets.dir_data(package_name, dataset_name*".gz")) || "Target file not exists or named correctly"

    @test !isfile(srcfile) || "srcfile should be moved to dir_raw()"
    @test isfile(SD.srcfile) || "SD.srcfile should be updated and the file should exists"
    @test isfile(SWCDatasets.dir_raw(basename(SD.srcfile))) || "srcfile should be moved to dir_raw()"

    rm("IRIS.csv")
    rm("data"; recursive = true)
end


@testset "Compress and Decompress" begin


    srcdir = SWCDatasets.dir_data("RDatasets")
    mkpath(srcdir)
    srcfile = joinpath(srcdir, "iris.csv")
    CSV.write(srcfile, iris)

    original = SWCDatasets.load_original(srcfile)

    # Test different methods for `return_compressed`
    compressed1 = SWCDatasets.return_compressed(original)
    compressed2 = SWCDatasets.return_compressed(srcfile)

    @test isequal(compressed1, compressed2)

    decompressed1 = transcode(CodecZlib.GzipDecompressor, compressed1)
    @test isequal(decompressed1, original)

    # Test compress_save
    SD = SWCDatasets.compress_save(srcfile; move_source=true) # KEYNOTE: test the alternative method
    target_path = SD.zipfile



    df_decomp2 = SWCDatasets.dataset(target_path)
    df_decomp1 = SWCDatasets.unzip_file(target_path)
    rm(basename(srcfile)) # By default iris.csv is uzipped to pwd
    df_decomp0 = CSV.read(SD.srcfile, DataFrame)


    @test isequal(df_decomp1, df_decomp0)
    @test isequal(df_decomp2, df_decomp0)


    package_name1, dataset_name1 = SWCDatasets.get_package_dataset_name(srcfile)
    package_name2, dataset_name2 = SWCDatasets.get_package_dataset_name(target_path)
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
