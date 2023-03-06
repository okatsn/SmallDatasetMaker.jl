@testset "datasets.jl" begin
    using DataFrames
    # There should be no datasets.csv
    @test try
        SmallDatasetMaker.datasets();
        false;
    catch e
        true;
    end

    # Create an empty datasets.csv.
    create_empty_table() # in fact, error will occur if there is a file already.

    # Even if it is created, .__datasets should be nothing until the first call of SmallDatasetMaker.datasets()
    @test isnothing(SmallDatasetMaker.__datasets)

    df = SmallDatasetMaker.datasets()
    @test isa(df, DataFrame)
    @test isa(SmallDatasetMaker.__datasets, DataFrame)
    rm(SmallDatasetMaker.dataset_table())
end
