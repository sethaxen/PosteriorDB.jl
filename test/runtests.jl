using PosteriorDB
using JSON3
using Test

@testset "PosteriorDB.jl" begin
    @testset "utils" begin
        @testset "recursive_stack" begin
            @test PosteriorDB.recursive_stack([1, 2]) == [1, 2]
            @test PosteriorDB.recursive_stack([[1, 2]]) == permutedims([1 2])
            @test PosteriorDB.recursive_stack([[1, 2], [3, 4]]) == reshape(1:4, 2, 2)
            @test PosteriorDB.recursive_stack(1) === 1
            @test PosteriorDB.recursive_stack(1:5) == 1:5
        end

        @testset "format_json_data" begin
            sz = (2, 3, 4)
            sample_dict = Dict(
                "Int" => 1,
                "Float64" => 2.5,
                "String" => "foo",
                "Vector{Int}" => [1, 2],
                "Vector{Float64}" => Union{Int,Float64}[1, 2.5],
                "Matrix{Float64}" => [randn(3), randn(3)],
                "Array{Float64,3}" =>
                    [[randn(4), randn(4), randn(4)], [randn(4), randn(4), randn(4)]],
            )
            sample_dict = merge(
                sample_dict,
                Dict(
                    "Dict{String,Any}" => sample_dict,
                    "Vector{Dict{String,Any}}" => [sample_dict],
                ),
            )
            s = JSON3.write(sample_dict)
            d = copy(JSON3.read(s))
            df = PosteriorDB.format_json_data(d)
            @test df isa Dict{String,Any}
            for (k, v) in df
                @test v isa eval(Meta.parse(k))
                v isa AbstractArray{<:Real} && @test size(v) == sz[1:ndims(v)]
            end
            for (k, v) in df["Dict{String,Any}"]
                @test v isa eval(Meta.parse(k))
                v isa AbstractArray{<:Real} && @test size(v) == sz[1:ndims(v)]
            end
            for (k, v) in df["Vector{Dict{String,Any}}"][1]
                @test v isa eval(Meta.parse(k))
                v isa AbstractArray{<:Real} && @test size(v) == sz[1:ndims(v)]
            end
        end
    end

    pdb = database()

    @testset "PosteriorDatabase" begin
        @test pdb isa PosteriorDatabase
        @test isdir(pdb.path)
    end

    @testset "posterior" begin
        posteriors = posterior_names(pdb)
        @test posteriors isa Vector{String}
        @test !isempty(posteriors)
        @testset "$n" for n in posteriors
            post = posterior(pdb, n)
            @test post isa Posterior
            @test name(post) == n
            @test database(post) == pdb
            @test info(post) isa Dict{String}
            mod = model(post)
            @test mod isa Model
            @test database(mod) === pdb
            data = dataset(post)
            @test data isa Dataset
            @test database(data) === pdb
            @test n == "$(name(data))-$(name(mod))" || (n == name(data) == name(mod))

            ref = reference_posterior(post)
            @test ref isa Union{ReferencePosterior,Nothing}
            if ref !== nothing
                @test name(ref) isa String
                @test database(ref) === pdb
                @test info(ref) isa Dict{String}
                load_values(ref)
            end
        end
    end

    @testset "model" begin
        models = model_names(pdb)
        @test models isa Vector{String}
        @test !isempty(models)
        @testset "$n" for n in models
            mod = model(pdb, n)
            @test mod isa Model
            @test name(mod) == n
            @test database(mod) == pdb
            @test info(mod) isa Dict{String}
            ppls = implementation_names(mod)
            @test ppls isa Vector{String}
            @test !isempty(ppls)
            @testset "$ppl" for ppl in ppls
                code = implementation(mod, ppl)
                @test code isa String
            end
        end
    end

    @testset "dataset" begin
        datasets = dataset_names(pdb)
        @test datasets isa Vector{String}
        @test !isempty(datasets)
        @testset "$n" for n in datasets
            data = dataset(pdb, n)
            @test data isa Dataset
            @test name(data) == n
            @test database(data) == pdb
            @test info(data) isa Dict{String}
            @test load_values(data) isa Dict{String}
        end
    end
end
