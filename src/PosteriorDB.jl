"""
    PosteriorDB

Functionality for working with instances of a posterior database.

See https://github.com/stan-dev/posteriordb for more information.
"""
module PosteriorDB

using JSON3, ZipFile
using Artifacts: @artifact_str
using Compat: stack

const POSTERIOR_DB_ARTIFACT_PATH = artifact"posteriordb"
const POSTERIOR_DB_DEFAULT_PATH = joinpath(
    POSTERIOR_DB_ARTIFACT_PATH, readdir(POSTERIOR_DB_ARTIFACT_PATH)[1], "posterior_database"
)

include("utils.jl")
include("common.jl")
include("posterior_database.jl")
include("model.jl")
include("dataset.jl")
include("posterior.jl")
include("reference_posterior.jl")

export Dataset, Model, Posterior, PosteriorDatabase, ReferencePosterior
export database,
    dataset,
    dataset_names,
    implementation,
    implementation_names,
    info,
    load_values,
    model,
    model_names,
    name,
    posterior,
    posterior_names,
    reference_posterior

end
