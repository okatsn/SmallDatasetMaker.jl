# Example

## List available datasets

```@example a123
using SWCExampleDatasets
SWCExampleDatasets.datasets()
```

which is equivalent to:

```@example b123
using SWCExampleDatasets, SmallDatasetMaker
SWCExampleDatasets.datasets(SWCExampleDatasets)
```

Or, alternatively, 

```@example a123
SWCExampleDatasets.__datasets
```

## Load a specific dataset

```@example a123
df = SWCExampleDatasets.dataset("NCUWiseLab", "ARI_G2F820_example")
df[1:5, :]
```

which is equivalent to:

```@example b123
df = SmallDatasetMaker.dataset(SWCExampleDatasets, "NCUWiseLab", "ARI_G2F820_example")
df[1:5, :]
```