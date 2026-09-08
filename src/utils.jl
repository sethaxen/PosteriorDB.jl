load_json(path) = format_json_data(open(JSON3.read, path, "r"))

function load_zipped_file(f, path)
    reader = ZipFile.Reader(path)
    filename = splitext(basename(path))[1]
    files = filter(file -> file.name == filename, reader.files)
    nfiles = length(files)
    if nfiles != 1
        throw(
            ArgumentError(
                "Expected zip archive $path to contain exactly one file named $filename. Found $nfiles",
            ),
        )
    end
    result = f(first(files))
    close(reader)
    return result
end

load_zipped_json(path) = load_zipped_file(format_json_data ∘ JSON3.read, path)

load_zipped_string(path) = load_zipped_file(Base.Fix2(read, String), path)

function filenames_no_extension(path, ext; kwargs...)
    filenames = filter!(Base.Fix2(endswith, ext), readdir(path; kwargs...))
    return map(fn -> fn[1:(end - length(ext))], filenames)
end

format_json_data(data) = data
function format_json_data(data::AbstractDict)
    return OrderedDict{String,Any}(string(k) => format_json_data(v) for (k, v) in data)
end
format_json_data(data::AbstractVector{<:AbstractDict}) = map(format_json_data, data)
function format_json_data(data::AbstractVector)
    arr = recursive_stack(_asarray, data)
    dims = ntuple(identity, ndims(arr))
    arr_perm = permutedims(arr, reverse(dims))
    S = Base.promote_union(eltype(arr_perm))
    return convert(Array{S}, arr_perm)
end

_asarray(data::Array) = data
_asarray(data::JSON3.Array) = copy(data)

"""
    recursive_stack(x::AbstractArray)

If `x` is an array of arrays, recursively stack into a single array whose dimensions are
ordered with dimensions of the innermost container first and outermost last.
"""
recursive_stack(f, x) = x
recursive_stack(f, x::AbstractArray{<:AbstractArray}) = recursive_stack(f, stack(f, x))
