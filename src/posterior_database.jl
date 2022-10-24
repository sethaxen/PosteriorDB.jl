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
"""
database(path::String=POSTERIOR_DB_DEFAULT_PATH) = PosteriorDatabase(path)

Base.show(io::IO, ::PosteriorDatabase) = print(io, "PosteriorDatabase(...)")

"""
    posterior_names(db::PosteriorDatabase) -> Vector{String}

Return the names of all posteriors in the database.
"""
function posterior_names(db::PosteriorDatabase)
    return filenames_no_extension(joinpath(db.path, "posteriors"), ".json")
end

"""
    model_names(db::PosteriorDatabase) -> Vector{String}

Return the names of all models in the database.
"""
function model_names(db::PosteriorDatabase)
    return filenames_no_extension(joinpath(db.path, "models", "info"), ".info.json")
end

"""
    dataset_names(db::PosteriorDatabase) -> Vector{String}

Return the names of all datasets in the database.
"""
function dataset_names(db::PosteriorDatabase)
    return filenames_no_extension(joinpath(db.path, "data", "info"), ".info.json")
end

function posterior_info_path(db::PosteriorDatabase, name::String)
    return joinpath(db.path, "posteriors", "$name.json")
end

function reference_posterior_info_path(db::PosteriorDatabase, name::String)
    return joinpath(db.path, "reference_posteriors", "draws", "info", "$name.info.json")
end

function reference_posterior_draws_path(db::PosteriorDatabase, name::String)
    return joinpath(db.path, "reference_posteriors", "draws", "draws", "$name.json.zip")
end

function model_info_path(db::PosteriorDatabase, name::String)
    return joinpath(db.path, "models", "info", "$name.info.json")
end

function data_info_path(db::PosteriorDatabase, name::String)
    return joinpath(db.path, "data", "info", "$name.info.json")
end
