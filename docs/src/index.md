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
pdb = database()
path(pdb)
```

For now, the database is read-only.
We can list the available posteriors with [`posterior_names`](@ref).

```@repl usage
posterior_names(pdb)
```

We can also list available models with [`model_names`](@ref) and datasets with [`dataset_names`](@ref).

```@repl usage
model_names(pdb)
dataset_names(pdb)
```

We can fetch a posterior using its name and [`posterior`](@ref).

```@repl usage
post = posterior(pdb, "eight_schools-eight_schools_centered")
```

Each posterior has a corresponding model and dataset, which can be fetched with [`model`](@ref) and [`dataset`](@ref).

```@repl usage
mod = model(post)
data = dataset(post)
```

The same model and dataset can be accessed directly from the database.

```@repl usage
model(pdb, "eight_schools_centered")
dataset(pdb, "eight_schools")
```

The functions [`database`](@ref), [`name`](@ref), and [`info`](@ref) can be applied to any posterior, model, or dataset.

```@repl usage
database(post)
name(post)
info(post)
```

From the model we can access implementation code and model information.

```@repl usage
impl = implementation(mod, "stan")
path(impl)
mod_code = load(impl)
println(mod_code)
info(mod)
```

We can access information about the dataset and load it with [`load`](@ref).

```@repl usage
info(data)
path(data)
load(data)
load(data, String)
```

Lastly, we can access gold standard posterior draws with [`reference_posterior`](@ref) and [`load`](@ref).

```@repl usage
ref = reference_posterior(post)
info(ref)
path(ref)
using DataFrames
DataFrame(load(ref))
load(ref, String)
```
