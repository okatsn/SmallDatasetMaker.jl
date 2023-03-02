@testset "SourceData" begin
    using CSV,RDatasets
    iris = RDatasets.dataset("datasets", "iris")
    srcdir = SWCDatasets.dir_data("temp","RDatasets")
    mkpath(srcdir)
    srcfile = joinpath(srcdir, "iris.csv")
    CSV.write(srcfile, iris)
    SD = SourceData(srcfile)
    @test SD.package_name == "RDatasets"
    @test SD.dataset_name == "iris"
    @test SD.zipfile == SWCDatasets.dir_data("RDatasets", "iris"*".gz")
    rm(SWCDatasets.dir_data("temp");recursive=true)
end
