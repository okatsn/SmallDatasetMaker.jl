# Changelog

## v0.0.3
- Based on `SWCDatasets` `v"0.2.5"`
- Extend methods for external package use.
- All tests passed.


## v0.1.0
- All directory references are based on the external Module (the package that `SmallDatasetMaker` makes).

## v0.1.1
- New internal function `abspath!` and `relpath!`
- Fix path referencing
    - `compress_save(mod::Module, SD::SourceData;...)`, `compress_save!` now returns `SD` of **relative path** to the dataset.
    - Remove `SourceData(mod::Module, args...)` method
    - `SourceData(mod::Module, row::DataFrameRow)` returns **absolute path** to the dataset.

## v0.1.4
- Make `__datasets` constant instead, to avoid undesirable behavior when multiple datasets made with `SmallDatasetMaker` were loaded.
- An assistant tool `tryparse_summary` for user to check whether the dataset to be made can be parsed to the target types.