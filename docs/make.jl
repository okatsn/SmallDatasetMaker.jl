using SmallDatasetMaker, SWCExampleDatasets
using Documenter

DocMeta.setdocmeta!(SmallDatasetMaker, :DocTestSetup, :(using SmallDatasetMaker, SWCExampleDatasets); recursive=true)

makedocs(;
    modules=[SmallDatasetMaker],
    authors="okatsn <okatsn@gmail.com> and contributors",
    repo="https://github.com/okatsn/SmallDatasetMaker.jl/blob/{commit}{path}#{line}",
    sitename="SmallDatasetMaker.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://okatsn.github.io/SmallDatasetMaker.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Index" => "index.md",
        "Introduction" => "README.md",
        "Example" => "example.md",
        "Assistant tools" => "assisttools.md"
    ],
)

deploydocs(;
    repo="github.com/okatsn/SmallDatasetMaker.jl",
    devbranch="main",
)
