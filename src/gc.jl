"""
`cleantable(mod::Module)` remove redundant entries of the `dataset_table(mod)` **and overwrite** `data/docs/datasets.csv`. Use with caution and verify before commit & push.


"""
function cleantable(mod)
    reftablepath = dataset_table(mod)
    df = CSV.read(reftablepath, DataFrame)
    df_lite = combine(groupby(df, [:PackageName, :Dataset]; sort = false), last)
    CSV.write(reftablepath, df_lite)
end
