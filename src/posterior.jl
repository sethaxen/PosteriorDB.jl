"""
    Posterior

Pointer to a posterior in a [`PosteriorDatabase`](@ref).

See also: [`posterior`](@ref), [`posterior_names`](@ref)
"""
struct Posterior
    db::PosteriorDatabase
    name::String
end

Base.show(io::IO, p::Posterior) = print(io, "Posterior: ", name(p))

"""
    posterior(db::PosteriorDatabase, name::String) -> Posterior

Return a posterior object for the posterior with name `name` in the database `db`.
"""
posterior(db::PosteriorDatabase, name::String) = Posterior(db, name)

name(p::Posterior) = p.name
database(p::Posterior) = p.db
info(p::Posterior) = load_json(posterior_info_path(database(p), name(p)))

"""
    model(posterior::Posterior) -> Model

Return the model entry of `posterior`.
"""
model(p::Posterior) = model(database(p), info(p)["model_name"])

"""
    dataset(posterior::Posterior) -> Dataset

Return the dataset entry of `posterior`.
"""
dataset(p::Posterior) = dataset(database(p), info(p)["data_name"])

"""
    reference_posterior(posterior::Posterior) -> Union{Nothing,ReferencePosterior}

Return the reference posterior entry of `posterior`.

If no reference posterior is available, `nothing` is returned.
"""
function reference_posterior(p::Posterior)
    ref_name = info(p)["reference_posterior_name"]
    ref_name === nothing && return nothing
    return reference_posterior(database(p), ref_name)
end
