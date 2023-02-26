```@meta
CurrentModule = PosteriorDB
```

# PosteriorDB.jl

PosteriorDB.jl is a Julia package for easily working with a [posteriordb](https://github.com/stan-dev/posteriordb) database.
It includes convenience functions for accessing data, model code, and information for individual posteriors, models, data, and reference draws.

## Installation

PosteriorDB can be installed from the Julia general registry with

```julia
] add PosteriorDB
```

## Example usage

When PosteriorDB.jl is installed, a copy of posteriordb is downloaded.
When a database is created with [`database`](@ref), this is automatically used.

```@repl usage
using PosteriorDB
pdb = PosteriorDB.database()
PosteriorDB.path(pdb)
```

For now, the database is read-only.
We can list the available posteriors with [`posterior_names`](@ref).

```@repl usage
PosteriorDB.posterior_names(pdb)
```

We can also list available models with [`model_names`](@ref) and datasets with [`dataset_names`](@ref).

```@repl usage
PosteriorDB.model_names(pdb)
PosteriorDB.dataset_names(pdb)
```

We can fetch a posterior using its name and [`posterior`](@ref).

```@repl usage
post = PosteriorDB.posterior(pdb, "eight_schools-eight_schools_centered")
```

Each posterior has a corresponding model and dataset, which can be fetched with [`model`](@ref) and [`dataset`](@ref).

```@repl usage
mod = PosteriorDB.model(post)
data = PosteriorDB.dataset(post)
```

The same model and dataset can be accessed directly from the database.

```@repl usage
PosteriorDB.model(pdb, "eight_schools_centered")
PosteriorDB.dataset(pdb, "eight_schools")
```

The functions [`database`](@ref), [`name`](@ref), and [`info`](@ref) can be applied to any posterior, model, or dataset.

```@repl usage
PosteriorDB.database(post)
PosteriorDB.name(post)
PosteriorDB.info(post)
```

From the model we can access implementation code and model information.

```@repl usage
impl = PosteriorDB.implementation(mod, "stan")
PosteriorDB.path(impl)
mod_code = PosteriorDB.load(impl)
println(mod_code)
PosteriorDB.info(mod)
```

We can access information about the dataset and load it with [`load`](@ref).

```@repl usage
PosteriorDB.info(data)
PosteriorDB.path(data)
PosteriorDB.load(data)
PosteriorDB.load(data, String)
```

Lastly, we can access gold standard posterior draws with [`reference_posterior`](@ref) and [`load`](@ref).

```@repl usage
ref = PosteriorDB.reference_posterior(post)
PosteriorDB.info(ref)
PosteriorDB.path(ref)
using DataFrames
DataFrame(PosteriorDB.load(ref))
PosteriorDB.load(ref, String)
```
