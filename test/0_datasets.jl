@testset "datasets.jl" begin
    using DataFrames
    @test isnothing(SWCDatasets.__datasets)
    df = SWCDatasets.datasets()
    @test isa(df, DataFrame)
    @test isa(SWCDatasets.__datasets, DataFrame)
end
