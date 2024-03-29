"""
Given a series of `DataFrame`s,
`difftables(df0::AbstractDataFrame, dfs::AbstractDataFrame...; ignoring = Cols())` returns `report::DataFrame` with columns
- `:nrow`: number of rows of each `DataFrame`.
- `:ncol`: number of columns of each `DataFrame`.
- `:cols_lack`: lack of columns comparing to `df0`.
- `:cols_add`:  extra columns comparing to `df0`.

This function is useful for update an existing dataset (where the new data might have unidentical column names).
"""
function difftables(df0::AbstractDataFrame, dfs::AbstractDataFrame...; ignoring = Cols())
    df0 = select(deepcopy(df0), Not(ignoring))
    dfs = [select(deepcopy(df), Not(ignoring)) for df in dfs]
    base_cols = [k for (k, v) in pairs(eachcol(df0))]
    report = DataFrame(
        :nrow      => [nrow(df0)],
        :ncol      => [ncol(df0)],
        :cols_lack => [Symbol[]],
        :cols_add  => [Symbol[]]
    )
    for df in dfs
        table2s_cols = [k for (k, v) in pairs(eachcol(df))]
        rp = DataFrame(
            :nrow => [nrow(df)],
            :ncol => [ncol(df)],
            :cols_lack => [[col for col in base_cols if !in(col, table2s_cols)]],
            :cols_add => [[col for col in table2s_cols if !in(col, base_cols)]]
        )
        append!(report, rp)
    end
    return report
end
