function difftable(df0::AbstractDataFrame, dfs::AbstractDataFrame...)
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
            :excessive_cols => [Symbol[]],
            :deficient_cols => [[col for col in cols if !in(col, base_cols)]]
        )
        append!(report, rp)
    end
    return report
end
