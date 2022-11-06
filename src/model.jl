"""
    Model

Pointer to a model in a [`PosteriorDatabase`](@ref).

See also: [`model`](@ref), [`model_names`](@ref)
"""
struct Model
    db::PosteriorDatabase
    name::String
end

function Base.show(io::IO, m::Model)
    print(io, "Model: ", name(m))
    i = info(m)
    if haskey(i, "title")
        println(io)
        print(io, "Title: ", i["title"])
    end
    if haskey(i, :model_implementations)
        println(io)
        print(
            io, "Implementations: ", join(collect(keys(i["model_implementations"])), ", ")
        )
    end
    return nothing
end

"""
    model(db::PosteriorDatabase, name::String) -> Model

Return a model object for the model with name `name` in the database `db`.
"""
model(db::PosteriorDatabase, name::String) = Model(db, name)

name(m::Model) = m.name
database(m::Model) = m.db
info(m::Model) = load_json(model_info_path(database(m), name(m)))

"""
    implementation_names(model::Model) -> Vector{String}

Return the names of frameworks with code for the `model`.
"""
function implementation_names(m::Model)
    return map(String, collect(keys(info(m)["model_implementations"])))
end
