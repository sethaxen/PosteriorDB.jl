using PosteriorDB
using Documenter

DocMeta.setdocmeta!(PosteriorDB, :DocTestSetup, :(using PosteriorDB); recursive=true)

makedocs(;
    modules=[PosteriorDB],
    authors="Seth Axen <seth@sethaxen.com> and contributors",
    repo="https://github.com/sethaxen/PosteriorDB.jl/blob/{commit}{path}#{line}",
    sitename="PosteriorDB.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://sethaxen.github.io/PosteriorDB.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/sethaxen/PosteriorDB.jl",
    devbranch="main",
)
