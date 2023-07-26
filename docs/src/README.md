# Introduction

Inspired by [RDatasets.jl](https://github.com/JuliaStats/RDatasets.jl), [SmallDatasetMaker](https://github.com/okatsn/SmallDatasetMaker.jl) provides tools to create/add/update a julia package of datasets in only a few steps.


## Getting started

```@setup thispage
using SmallDatasetMaker
```

### 1. Create a package
Create a julia package, for example, `YourDatasets.jl`. For convenience, `YourDatasets` in this documentation refers an arbitrary package of datasets working with `SmallDatasetMaker` herein after.

See [PkgTemplates](https://github.com/JuliaCI/PkgTemplates.jl) and [Pkg.jl/Creating Packages](https://pkgdocs.julialang.org/v1/creating-packages/) about how to create a julia package.

`SmallDatasetMaker` should be added to the `Project.toml` `of YourDatasets`:
- `(YourDatasets) pkg> add SmallDatasetMaker`


### 2. Convert the raw data to a dataset

!!! note 
    Activate the environment `YourDatasets` and `using SmallDatasetMaker` first!

1. Make your dataset to be compressed a csv file.
2. Define the `SourceData` object with the `srcpath` to be the path to this csv file.
3. Call `compress_save!` or `compress_save`.

```@docs
SourceData
compress_save!
compress_save
```

### 3. Add methods `dataset` and `datasets`
- `using SmallDatasetMaker` in the module scope of `YourDatasets`
- (Optional) New methods for `dataset` and `datasets`.

#### Example

In `src/YourDatasets.jl`:

```julia

module YourDatasets

    using SmallDatasetMaker
   # (required) See also `SmallDatasetMaker.datasets`.

    function YourDatasets.dataset(package_name, dataset_name)
        SmallDatasetMaker.dataset(YourDatasets,package_name, dataset_name)
    end 
    # (optional but recommended) 
    # To allow direct use of `dataset` without `SmallDatasetMaker`.

    YourDatasets.datasets() = SmallDatasetMaker.datasets(YourDatasets) 
    # (optional but recommended) To allow the direct use of `YourDatasets.datasets()`
end

```

### 4. Use `YourDatasets`

In the case new methods `YourDatasets.dataset` and `YourDatasets.datasets` has been created:
```julia-repl
using YourDatasets
YourDatasets.datasets() # a DataFrame for all availabe packages and datasets
df = YourDatasets.dataset("LHVRSHIVA", "SHIVA") # load dataset "SHIVA" in package "LHVRSHIVA" as a DataFrame
```

In the case new methods `YourDatasets.dataset` and `YourDatasets.datasets()` has **NOT** been created:
```julia-repl
using YourDatasets, SmallDatasetMaker
SmallDatasetMaker.datasets(YourDatasets)
df = SmallDatasetMaker.dataset(YourDatasets, "LHVRSHIVA", "SHIVA")
```

See also [Example](@ref).

## Best practice/Hints

#### Keep the default branch clean without raw data
- Commit and push only the compressed .gz files and the updated `data/doc/datasets.csv`
- You may work on an alternative branch, e.g. `new-dataset-from-raw`, and use `git merge --no-ff new-dataset-from-raw` to your default branch and manually un-stage all artifacts.

!!! note ""
    - Noted that if the default branch isn't clean, `pkg> add YourDatasets` will take extra unnecessary disk space.
    - You may simply follow the hygiene of 
      - always place raw data in `data/raw/` and 
      - add `data/raw/` in `.gitignore`


## Optional
### Test
You may also optionally have the following tests in `YourDatasets`:

**Test if the table to the list of `YourDatasets` is fine**:
```julia
@testset "Test if datasets() works" begin
    using DataFrames
    df = YourDatasets.datasets()
    @test isa(df, DataFrame)
    @test isa(YourDatasets.__datasets, DataFrame)
end

```


```julia
@testset "Test if ALL datasets can be successfully loaded." begin
    using DataFrames
    for lastrow in eachrow(YourDatasets.__datasets)
        pkgnm = lastrow.PackageName
        datnm = lastrow.Dataset
        df = YourDatasets.dataset(pkgnm, datnm)
        @info "$pkgnm/$datnm goes through `PrepareTableDefault` without error."
        @test lastrow.Columns == ncol(df)
        @test lastrow.Rows == nrow(df)
    end
    @test true
end
```

## See also
### How `dataset` and `datasets` work

See also
```@docs
SmallDatasetMaker.datasets
SmallDatasetMaker.dataset
```

### How `package_name` and `dataset_name` is automatically determined:
```julia
SD = SourceData("data/raw/Hello/world.csv");
(SD.package_name, SD.dataset_name)
```
```@example thispage
SmallDatasetMaker.get_package_dataset_name("data/raw/Hello/world.csv") #hide
```


See also
```@docs
SmallDatasetMaker.get_package_dataset_name
```


### Where is the raw data
```@docs
SmallDatasetMaker.dir_raw
```

## Difference between the usage of `YourDatasets` and `RDatasets`
Here are the highlights of differences between the usage of `YourDatasets` (created by `SmallDatasetMaker`) and `RDatasets`:
- For `RDatasets`, `RDatasets.__datasets` is a `global` variable; whereas `YourDatasets.__datasets` is a `const` variable.