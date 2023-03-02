@testset "datasets.jl" begin
    using DataFrames
    @test isnothing(SmallDatasetMaker.__datasets)
    df = SmallDatasetMaker.datasets()
    @test isa(df, DataFrame)
    @test isa(SmallDatasetMaker.__datasets, DataFrame)
end
