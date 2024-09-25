# Guide for testing your dataset

## Example

```@example
using SWCExampleDatasets, Test
using DataFrames, SmallDatasetMaker

@testset "Test All Datasets" begin
    
    dataset0 = SWCExampleDatasets.__datasets

    for lastrow in eachrow(SmallDatasetMaker.lastestentry(dataset0))
        pkgnm = lastrow.PackageName
        datnm = lastrow.Dataset
        df = SWCExampleDatasets.dataset(pkgnm, datnm)
        @info "$pkgnm/$datnm goes through `PrepareTableDefault` without error."
        @test lastrow.Columns == ncol(df)
        @test lastrow.Rows == nrow(df)
    end
    @test true
end

nothing
```