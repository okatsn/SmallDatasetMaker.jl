# SmallDatasetMaker

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://okatsn.github.io/SmallDatasetMaker.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://okatsn.github.io/SmallDatasetMaker.jl/dev/)
[![Build Status](https://github.com/okatsn/SmallDatasetMaker.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/okatsn/SmallDatasetMaker.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/okatsn/SmallDatasetMaker.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/okatsn/SmallDatasetMaker.jl)

<!-- Don't have any of your custom contents above; they won't occur if there is no citation. -->

## Introduction

This is a julia package created using `okatsn`'s preference, and this package is expected to be registered to [okatsn/OkRegistry](https://github.com/okatsn/OkRegistry) for CIs to work properly.

!!! note Checklist
    - [x] Create an empty repository (namely, `https://github.com/okatsn/SmallDatasetMaker.jl.git`) on github, and push the local to origin. See [connecting to remote](#tips-for-connecting-to-remote).
    - [x] Add `ACCESS_OKREGISTRY` secret in the settings of this repository on Github, or delete both `register.yml` and `TagBot.yml` in `/.github/workflows/`. See [Auto-Registration](#auto-registration).

## References


### Test
#### How to add a new test
Add `.jl` files (that has `@testset` block or `@test` inside) in `test/`; `test/runtests.jl` will automatically `include` all the `.jl` scripts there.

#### Test docstring
`doctest` is executed at the following **two** places:
1. In `CI.yml`, `jobs: test: ` that runs `test/runtests.jl`
2. In `CI.yml`, `jobs: docs: ` that runs directly on bash.

It is no harm to run both, but you can manually delete either.
Of course, `pkg> test` will also run `doctest` since it runs also `test/runtests.jl`.


This package is create on 2023-03-02.
