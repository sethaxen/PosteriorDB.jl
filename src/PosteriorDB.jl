"""
    PosteriorDB

Functionality for working with instances of a posterior database.

See https://github.com/stan-dev/posteriordb for more information.
"""
module PosteriorDB

using JSON3, ZipFile
using Compat: stack
VERSION ≥ v"1.3" && using Artifacts

include("utils.jl")
include("common.jl")
include("posterior_database.jl")
include("model.jl")
include("implementation.jl")
include("dataset.jl")
include("posterior.jl")
include("reference_posterior.jl")

export AbstractImplementation,
    Dataset,
    Model,
    Posterior,
    PosteriorDatabase,
    PyMC3ModelImplementation,
    ReferencePosterior,
    StanModelImplementation
export database,
    dataset,
    dataset_names,
    implementation,
    implementation_names,
    info,
    load,
    model,
    model_names,
    name,
    path,
    posterior,
    posterior_names,
    reference_posterior

end
