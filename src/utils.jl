load_json(path) = format_json_data(copy(open(JSON3.read, path, "r")))

function load_zipped_json(path)
    reader = ZipFile.Reader(path)
    files = reader.files
    nfiles = length(files)
    if nfiles > 1
        throw(
            ArgumentError(
                "Expected a zip archive containing a single file. Path $path contains $nfiles files",
            ),
        )
    end
    contents = copy(JSON3.read(first(files)))
    close(reader)
    return format_json_data(contents)
end

function filenames_no_extension(path, ext; kwargs...)
    filenames = filter!(Base.Fix2(endswith, ext), readdir(path; kwargs...))
    return map(fn -> fn[1:(end - length(ext))], filenames)
end

format_json_data(data) = data
function format_json_data(data::AbstractDict)
    return Dict{String,Any}(string(k) => format_json_data(v) for (k, v) in data)
end
format_json_data(data::AbstractVector{<:AbstractDict}) = map(format_json_data, data)
function format_json_data(data::AbstractVector)
    arr = recursive_stack(data)
    dims = ntuple(identity, ndims(arr))
    arr_perm = permutedims(arr, reverse(dims))
    S = Base.promote_union(eltype(arr_perm))
    return convert(Array{S}, arr_perm)
end

"""
    recursive_stack(x::AbstractArray)

If `x` is an array of arrays, recursively stack into a single array whose dimensions are
ordered with dimensions of the innermost container first and outermost last.
"""
recursive_stack(x) = x
recursive_stack(x::AbstractArray{<:AbstractArray}) = recursive_stack(stack(x))
