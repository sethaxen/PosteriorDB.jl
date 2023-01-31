"""
    ReferencePosterior

Pointer to a reference posterior in a [`PosteriorDatabase`](@ref).

See also: [`Posterior`](@ref), [`reference_posterior`](@ref), [`posterior`](@ref)
"""
struct ReferencePosterior
    db::PosteriorDatabase
    name::String
end

Base.show(io::IO, r::ReferencePosterior) = print(io, "Reference posterior: ", name(r))

"""
    reference_posterior(db::PosteriorDatabase, name::String) -> ReferencePosterior

Return a pointer to the reference posterior with name `name` in the database `db`.
"""
reference_posterior(db::PosteriorDatabase, name::String) = ReferencePosterior(db, name)

database(r::ReferencePosterior) = r.db
name(r::ReferencePosterior) = r.name
info(r::ReferencePosterior) = load_json(reference_posterior_info_path(database(r), name(r)))

"""
    path(rp::ReferencePosterior) -> String

Return the path to the file storing the reference draws for the reference posterior `rp`.
"""
path(r::ReferencePosterior) = reference_posterior_draws_path(database(r), name(r))

"""
    load(rp::ReferencePosterior) -> Vector{Dict{String,Any}}

Load and return the reference draws for the reference posterior `rp`.

    load(rp::ReferencePosterior, String) -> String

Return the reference draws as an unparsed JSON string.
"""
load(r::ReferencePosterior) = load_zipped_json(path(r))
load(r::ReferencePosterior, ::Type{String}) = load_zipped_string(path(r))
