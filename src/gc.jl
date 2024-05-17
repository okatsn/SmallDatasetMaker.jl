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
    df_lite = combine(groupby(df, [:PackageName, :Dataset]; sort = false), last)
    CSV.write(reftablepath, df_lite)
end

"""
`gc(mod::Module)`.
Remove **ALL** datasets that are not in `data/doc/datasets.csv`, except `data/raw/*` and`data/doc/*` . Use with caution and verify before commit & push.

```julia
using SmallDatasetMaker, YourDatasets
SmallDatasetMaker.gc(YourDatasets)
```
"""
function gc(mod::Module)
    reftablepath = dataset_table(mod)
    filelistall(dir_data(mod))
end
