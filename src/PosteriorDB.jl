"""
    PosteriorDB

Functionality for working with instances of a posterior database.

See https://github.com/stan-dev/posteriordb for more information.
"""
module PosteriorDB

using JSON3, ZipFile
using OrderedCollections: OrderedDict
using Compat: stack
using Artifacts

include("utils.jl")
include("common.jl")
include("posterior_database.jl")
include("model.jl")
include("implementation.jl")
include("dataset.jl")
include("posterior.jl")
include("reference_posterior.jl")

end
