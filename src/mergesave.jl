

function merge_save(package_name::AbstractString, dataset_name::AbstractString, df1::DataFrame; on = :datetime)
    df0 = dataset(package_name, dataset_name)
    df2 = outerjoin(df0, df1; on=on, makeunique=true)
    # CHECKPOINT: You have to merge duplicated columns

    rawfile = dir_raw(package_name, dataset_name*".csv")
    OkFiles.mkdirway(rawfile) # simply mkpath up to dirname(rawfile)
    CSV.write(df2, rawfile) # save the merged table
    compress_save(rawfile; move_source=false)


end
