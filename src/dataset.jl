"""
    Dataset

Pointer to a dataset in a [`PosteriorDatabase`](@ref).

See also: [`dataset`](@ref), [`dataset_names`](@ref)
"""
struct Dataset
    db::PosteriorDatabase
    name::String
end

function Base.show(io::IO, d::Dataset)
    print(io, "Dataset: ", name(d))
    i = info(d)
    if haskey(i, "title")
        println(io)
        print(io, "Title: ", i["title"])
    end
    return nothing
end

"""
    dataset(db::PosteriorDatabase, name::String) -> Dataset

Return a dataset object for the dataset with name `name` in the database `db`.
"""
dataset(db::PosteriorDatabase, name::String) = Dataset(db, name)

name(d::Dataset) = d.name
database(d::Dataset) = d.db
info(d::Dataset) = load_json(data_info_path(database(d), name(d)))

path(d::Dataset) = joinpath(path(database(d)), "$(info(d)["data_file"]).zip")

"""
    load(dataset::Dataset) -> Dict{String,Any}

Load and return the data for `dataset`.
"""
load(d::Dataset) = load_zipped_json(path(d))
