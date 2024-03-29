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

"""
    path(dataset::Dataset) -> String

Absolute path to the file containing the model `dataset`.
"""
path(d::Dataset) = joinpath(path(database(d)), "$(info(d)["data_file"]).zip")

"""
    load(dataset::Dataset) -> OrderedDict{String,Any}

Load and return the data for `dataset`.

    load(dataset::Dataset, String) -> String

Return the data for `dataset` as an unparsed JSON string.
"""
load(d::Dataset) = load_zipped_json(path(d))
load(d::Dataset, ::Type{String}) = load_zipped_string(path(d))
