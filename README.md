# SmallDatasetMaker

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://okatsn.github.io/SmallDatasetMaker.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://okatsn.github.io/SmallDatasetMaker.jl/dev/)
[![Build Status](https://github.com/okatsn/SmallDatasetMaker.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/okatsn/SmallDatasetMaker.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/okatsn/SmallDatasetMaker.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/okatsn/SmallDatasetMaker.jl)

<!-- Don't have any of your custom contents above; they won't occur if there is no citation. -->

## Introduction

This is a julia package created using `okatsn`'s preference, and this package is expected to be registered to [okatsn/OkRegistry](https://github.com/okatsn/OkRegistry) for CIs to work properly.

`SmallDatasetMaker` provides tools for making your own dataset as a julia package.
### Procedure
In for example, `MyDataset`,
1. Make your dataset to be compressed a csv file.
2. Define the `SourceData` object with the `srcpath` to be the path to this csv file.
3. Call `compress_save!`.
4. `using SmallDatasetMaker` in the module scope of `MyDataset`.
5. (Optional) Define and re-export the `dataset` function.

For example:

```julia
module MyDatasets
    using DrWatson
    include("projectdir.jl")


    using SmallDatasetMaker # This is required. See `SmallDatasetMaker.datasets`.
    function MyDatasets.dataset(package_name, dataset_name) 
        SmallDatasetMaker.dataset(MyDatasets,package_name, dataset_name)
    end
    export dataset
end

using MyDatasets
dataset("LHVRSHIVA", "SHIVA")
```

!!! note Keep the default branch clean!
    - Commit and push only the compressed .gz files and the updated `data/doc/datasets.csv`
    - You may work on an alternative branch, e.g. `new-dataset-from-raw`, and use `git merge --no-ff new-dataset-from-raw` to your default branch and manually un-stage all artifacts.
