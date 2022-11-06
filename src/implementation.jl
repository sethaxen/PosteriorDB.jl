"""
    AbstractImplementation

Abstract type for implementations of a model.

Subtypes should implement the methods [`load`](@ref) and [`path`](@ref).
"""
abstract type AbstractImplementation end

"""
    implementation(model::Model, framework::String) -> AbstractImplementation

Return the implementation of the `model` for the given `framework`.
"""
implementation(m::Model, framework::String) = implementation(m, Val(Symbol(framework)))

"""
    path(implementation::AbstractImplementation) -> String

Absolute path to the file containing the model `implementation`.
"""
path(::AbstractImplementation)

"""
    load(implementation::AbstractImplementation) -> String

Load the model `implementation` and return the code as a string.
"""
load(::AbstractImplementation)

"""
    StanModelImplementation

Implementation of a model using Stan.

See also: [`implementation`](@ref), [`load`](@ref)
"""
struct StanModelImplementation <: AbstractImplementation
    db::PosteriorDatabase
    path_rel::String
end

struct PyMC3ModelImplementation <: AbstractImplementation
    db::PosteriorDatabase
    path_rel::String
end

const StringModelImplementation = Union{StanModelImplementation,PyMC3ModelImplementation}

Base.show(io::IO, i::T) where {T<:StringModelImplementation} = print(io, "$T(...)")

function implementation(m::Model, ::Val{:stan})
    path_rel = info(m)["model_implementations"]["stan"]["model_code"]
    return StanModelImplementation(database(m), path_rel)
end
function implementation(m::Model, ::Val{:pymc3})
    path_rel = info(m)["model_implementations"]["pymc3"]["model_code"]
    return PyMC3ModelImplementation(database(m), path_rel)
end

database(impl::StringModelImplementation) = impl.db
path(impl::StringModelImplementation) = joinpath(path(database(impl)), impl.path_rel)
load(impl::StringModelImplementation) = read(path(impl), String)
