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
StanModelImplementation

for framework in ("Stan", "PyMC3", "PyMC")
    framework_lc = lowercase(framework)
    type_name = Symbol(framework*"ModelImplementation")
    @eval begin
        struct $type_name <: AbstractImplementation
            db::PosteriorDatabase
            path_rel::String
        end

        Base.show(io::IO, ::$type_name) = print(io, "$type_name(...)")

        function implementation(m::Model, ::Val{Symbol($framework_lc)})
            path_rel = info(m)["model_implementations"][$framework_lc]["model_code"]
            return $type_name(database(m), path_rel)
        end

        database(impl::$type_name) = impl.db
        path(impl::$type_name) = joinpath(path(database(impl)), impl.path_rel)
        load(impl::$type_name) = read(path(impl), String)
    end
end
