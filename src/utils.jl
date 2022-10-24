load_json(path) = open(JSON3.read, path, "r")

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
    contents = JSON3.read(first(files))
    close(reader)
    return contents
end

function filenames_no_extension(path, ext; kwargs...)
    filenames = filter!(endswith(ext), readdir(path; kwargs...))
    return map(fn -> fn[begin:(end - length(ext))], filenames)
end
