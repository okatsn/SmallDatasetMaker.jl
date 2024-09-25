"""
`cleantable(mod::Module)` remove redundant entries of the `dataset_table(mod)` **and overwrite** `data/doc/datasets.csv`. Use with caution and verify before commit & push.

# Example

```julia
using SmallDatasetMaker, YourDatasets
SmallDatasetMaker.cleantable(YourDatasets)
```
"""
function cleantable(mod::Module)
    reftablepath = dataset_table(mod)
    df = CSV.read(reftablepath, DataFrame)
    df_lite = lastestentry(df)
    CSV.write(reftablepath, df_lite)
end

function lastestentry(df)
    combine(groupby(df, [:PackageName, :Dataset]; sort=false), last)
end
