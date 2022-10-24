```@meta
CurrentModule = PosteriorDB
```

# PosteriorDB.jl

PosteriorDB.jl is a Julia package for easily working with a [posteriordb](https://github.com/stan-dev/posteriordb) database.
It includes convenience functions for accessing data, model code, and information for individual posteriors, models, data, and reference draws.

## Installation

This package is not yet registered.
For now, it can be installed directly from GitHub.

```julia
using Pkg
Pkg.add(url="https://github.com/sethaxen/PosteriorDB.jl")
```

## Example usage

When PosteriorDB.jl is installed, a copy of posteriordb is downloaded.
When a database is created with [`database`](@ref), this is automatically used.

```@repl usage
using PosteriorDB
pdb = database()
pdb.path
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
mod_code = implementation(mod, "stan")
println(mod_code)
info(mod)
```

We can access information about the dataset and load it with [`load_values`](@ref).

```@repl usage
info(data)
load_values(data)
```

Lastly, we can access gold standard posterior draws with [`reference_posterior`](@ref) and [`load_values`](@ref).

```@repl usage
ref = reference_posterior(post)
info(ref)
using DataFrames
DataFrame(load_values(ref))
```
