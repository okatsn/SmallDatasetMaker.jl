function difftables(df0::AbstractDataFrame, dfs::AbstractDataFrame...; ignoring = Cols())
    df0 = select(deepcopy(df0), Not(ignoring))
    dfs = [select(deepcopy(df), Not(ignoring)) for df in dfs]
    base_cols = [k for (k, v) in pairs(eachcol(df0))]
    report = DataFrame(
        :nrow => [nrow(df0)],
        :ncol => [ncol(df0)],
        :excessive_cols => [Symbol[]],
        :deficient_cols => [Symbol[]]
    )
    for df in dfs
        cols = [k for (k, v) in pairs(eachcol(df))]
        rp = DataFrame(
            :nrow => [nrow(df)],
            :ncol => [ncol(df)],
            :excessive_cols => [[col for col in base_cols if !in(col, cols)]],
            :deficient_cols => [[col for col in cols if !in(col, base_cols)]]
        )
        append!(report, rp)
    end
    return report
end
