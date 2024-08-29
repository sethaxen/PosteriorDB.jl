"""
    PosteriorDatabase

A posterior database object using the files at `path`.

See also: [`database`](@ref), [`posterior_names`](@ref), [`model_names`](@ref), [`dataset_names`](@ref)
"""
struct PosteriorDatabase
    path::String
end

"""
    database([path::String]) -> PosteriorDatabase

Return a pointer to the [`PosteriorDatabase`](@ref) stored at `path`.

If `path` is not given, the default posterior database downloaded from a GitHub release is
used.

!!! note
    Julia 1.3 or greater is required to use the default posterior database with `database()`.
"""
database
database(path::String) = PosteriorDatabase(path)

function database()
    artifact_path = artifact"posteriordb"
    path = joinpath(artifact_path, readdir(artifact_path)[1], "posterior_database")
    return database(path)
end

Base.show(io::IO, ::PosteriorDatabase) = print(io, "PosteriorDatabase(...)")

"""
    path(db::PosteriorDatabase) -> String

Absolute path to the database `db`.
"""
path(db::PosteriorDatabase) = db.path

"""
    posterior_names(db::PosteriorDatabase) -> Vector{String}

Return the names of all posteriors in the database.
"""
function posterior_names(db::PosteriorDatabase)
    return filenames_no_extension(joinpath(path(db), "posteriors"), ".json")
end

"""
    model_names(db::PosteriorDatabase) -> Vector{String}

Return the names of all models in the database.
"""
function model_names(db::PosteriorDatabase)
    return filenames_no_extension(joinpath(path(db), "models", "info"), ".info.json")
end

"""
    dataset_names(db::PosteriorDatabase) -> Vector{String}

Return the names of all datasets in the database.
"""
function dataset_names(db::PosteriorDatabase)
    return filenames_no_extension(joinpath(path(db), "data", "info"), ".info.json")
end

function posterior_info_path(db::PosteriorDatabase, name::String)
    return joinpath(path(db), "posteriors", "$name.json")
end

function reference_posterior_info_path(db::PosteriorDatabase, name::String)
    return joinpath(path(db), "reference_posteriors", "draws", "info", "$name.info.json")
end

function reference_posterior_draws_path(db::PosteriorDatabase, name::String)
    return joinpath(path(db), "reference_posteriors", "draws", "draws", "$name.json.zip")
end

function model_info_path(db::PosteriorDatabase, name::String)
    return joinpath(path(db), "models", "info", "$name.info.json")
end

function data_info_path(db::PosteriorDatabase, name::String)
    return joinpath(path(db), "data", "info", "$name.info.json")
end
