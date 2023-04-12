# Introduction

Inspired by [RDatasets.jl](https://github.com/JuliaStats/RDatasets.jl), [SmallDatasetMaker](https://github.com/okatsn/SmallDatasetMaker.jl) provides tools to create/add/update a julia package of datasets in only a few steps.


## Getting started

### Steps
#### 1. Create a package
Create a julia package, for example, `YourDatasets.jl`. For convenience, `YourDatasets` in this documentation refers an arbitrary package of datasets working with `SmallDatasetMaker` herein after.

See [PkgTemplates](https://github.com/JuliaCI/PkgTemplates.jl) and [Pkg.jl/Creating Packages](https://pkgdocs.julialang.org/v1/creating-packages/) about how to create a julia package.

#### 2. Convert the raw data to a dataset

1. Make your dataset to be compressed a csv file.
2. Define the `SourceData` object with the `srcpath` to be the path to this csv file.
3. Call `compress_save!`.
4. `using SmallDatasetMaker` in the module scope of `YourDatasets`.

```@docs
SourceData
compress_save!
```

#### 3. Add methods `dataset` and `datasets`
New methods for `dataset` and `datasets`; see the example below.

##### in `src/YourDatasets.jl`
```julia

module YourDatasets
    using DrWatson
    include("projectdir.jl") # optional

    using SmallDatasetMaker # (required) See also `SmallDatasetMaker.datasets`.
    function YourDatasets.dataset(package_name, dataset_name) 
        SmallDatasetMaker.dataset(YourDatasets,package_name, dataset_name)
    end # (optional)

    YourDatasets.datasets() = SmallDatasetMaker.datasets(YourDatasets) # (optional)
    # so that you can use `YourDatasets.datasets()` to list all availabe `package/dataest`s in `YourDatasets`
end

```

#### 4. Use `YourDatasets`
##### In julia REPL
```julia-repl
using YourDatasets
YourDatasets.datasets() # a DataFrame for all availabe packages and datasets
df = YourDatasets.dataset("LHVRSHIVA", "SHIVA") # load dataset "SHIVA" in package "LHVRSHIVA" as a DataFrame
```

### Best practice/Hints

#### Keep the default branch clean without raw data
- Commit and push only the compressed .gz files and the updated `data/doc/datasets.csv`
- You may work on an alternative branch, e.g. `new-dataset-from-raw`, and use `git merge --no-ff new-dataset-from-raw` to your default branch and manually un-stage all artifacts.

!!! note ""
    - If the default branch isn't clean, `pkg> add YourDatasets` will take several times larger disk space.
    - You may simply follow the hygiene of 
      - always place raw data in `data/raw/` and 
      - add `data/raw/` in `.gitignore`


### Optional
#### Test
You may also optionally have the following tests in `YourDatasets`:

**Test if the table to the list of `YourDatasets` is fine**:
```julia
@testset "datasets.jl" begin
    using DataFrames
    df = YourDatasets.datasets()
    @test isa(df, DataFrame)
    @test isa(YourDatasets.__datasets, DataFrame)
end

```

## Difference between the usage of `YourDatasets` and `RDatasets`

Here are the highlights of differences between the usage of `YourDatasets` (created by `SmallDatasetMaker`) and `RDatasets`:
- For `RDatasets`, `RDatasets.__datasets` is a `global` variable; whereas `YourDatasets.__datasets` is a `const` variable.