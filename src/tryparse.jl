struct NotException
    msg
end

"""
`tryparse_summary(v::AbstractVector, typetoparse::Type{<:Any})`

# Example
```jldoctest
julia> tryparse_summary(["1", "2", "3.3", 10, "NaN"], Float64) .|> typeof
5-element Vector{DataType}:
 SmallDatasetMaker.NotException
 SmallDatasetMaker.NotException
 SmallDatasetMaker.NotException
 MethodError
 SmallDatasetMaker.NotException
```
"""
function tryparse_summary(v::AbstractVector, typetoparse)
    excs = [_tryparse_summary(typetoparse, elem) for elem in v]
end

"""
`tryparse_summary(df::AbstractDataFrame, typetoparse)` returns a "long" dataframe with columns `:variable_name`, `:exception_type` and `:exception_msg`.

# Example
```@example
using DataFrames
df = DataFrame(
    :name => ["John", "Roe", "Mary", "Hello", "World"],
    :salary => [5.372, "1.1", "1", "NaN", "#value"],
    :age => string.([20, 13, 17, 22, 100])
)
summary = tryparse_summary(df, Float64)
combine(groupby(summary, [:variable_name, :exception_type, :exception_msg]), nrow)
```
"""
function tryparse_summary(df::AbstractDataFrame, typetoparse)
    summary = DataFrame(
        :variable_name  => Symbol[],
        :exception_type => DataType[],
        :exception_msg  => String[]
    )
    for (colnm, col) in pairs(eachcol(df))
        es = tryparse_summary(col, typetoparse)
        append!(summary,
            DataFrame(
                :variable_name  => colnm,
                :exception_type => [typeof(e) for e in es],
                :exception_msg  => _get_msg.(es)
            )
        )
    end
    return summary
end

function tryparse_replace()
    # TODO: replace by something if parse failed.
end


function _tryparse_summary(typetoparse::Type{<:Any}, elem)
    e = try
        parse(typetoparse, elem)
        NotException("Parse to $typetoparse successfully.")
    catch e
        e
    end
    return e
end


function _get_msg(e)
    msg = try
        e.msg
    catch
        string(e)
    end
    return msg
end
