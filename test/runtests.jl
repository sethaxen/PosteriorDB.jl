using Aqua
using PosteriorDB
using JSON3
using OrderedCollections: OrderedDict
using Test

POSTERIOR_DB_PATH = get(ENV, "POSTERIOR_DB_PATH", "")

@testset "PosteriorDB.jl" begin
    @testset "Aqua" begin
        Aqua.test_all(PosteriorDB)
        Aqua.test_ambiguities(PosteriorDB)
    end

    @testset "utils" begin
        @testset "recursive_stack" begin
            @test PosteriorDB.recursive_stack(identity, [1, 2]) == [1, 2]
            @test PosteriorDB.recursive_stack(identity, [[1, 2]]) == permutedims([1 2])
            @test PosteriorDB.recursive_stack(identity, [[1, 2], [3, 4]]) ==
                reshape(1:4, 2, 2)
            @test PosteriorDB.recursive_stack(identity, 1) === 1
            @test PosteriorDB.recursive_stack(identity, 1:5) == 1:5
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
                    "OrderedDict{String,Any}" => sample_dict,
                    "Vector{OrderedDict{String,Any}}" => [sample_dict],
                ),
            )
            s = JSON3.write(sample_dict)
            d = JSON3.read(s)
            df = PosteriorDB.format_json_data(d)
            @test df isa OrderedDict{String,Any}
            for (k, v) in df
                @test v isa eval(Meta.parse(k))
                v isa AbstractArray{<:Real} && @test size(v) == sz[1:ndims(v)]
            end
            for (k, v) in df["OrderedDict{String,Any}"]
                @test v isa eval(Meta.parse(k))
                v isa AbstractArray{<:Real} && @test size(v) == sz[1:ndims(v)]
            end
            for (k, v) in df["Vector{OrderedDict{String,Any}}"][1]
                @test v isa eval(Meta.parse(k))
                v isa AbstractArray{<:Real} && @test size(v) == sz[1:ndims(v)]
            end
        end
    end

    if isempty(POSTERIOR_DB_PATH)
        pdb = PosteriorDB.database()
    else
        pdb = PosteriorDB.database(POSTERIOR_DB_PATH)
    end

    @testset "PosteriorDatabase" begin
        @test pdb isa PosteriorDB.PosteriorDatabase
        @test isdir(PosteriorDB.path(pdb))
    end

    @testset "posterior" begin
        posteriors = PosteriorDB.posterior_names(pdb)
        @test posteriors isa Vector{String}
        @test !isempty(posteriors)
        @testset "$n" for n in posteriors
            post = PosteriorDB.posterior(pdb, n)
            @test post isa PosteriorDB.Posterior
            @test PosteriorDB.name(post) == n
            @test PosteriorDB.database(post) == pdb
            @test PosteriorDB.info(post) isa OrderedDict{String}
            mod = PosteriorDB.model(post)
            @test mod isa PosteriorDB.Model
            @test PosteriorDB.database(mod) === pdb
            data = PosteriorDB.dataset(post)
            @test data isa PosteriorDB.Dataset
            @test PosteriorDB.database(data) === pdb
            @test n == "$(PosteriorDB.name(data))-$(PosteriorDB.name(mod))" ||
                (n == PosteriorDB.name(data) == PosteriorDB.name(mod))
            ref = PosteriorDB.reference_posterior(post)
            @test ref isa Union{PosteriorDB.ReferencePosterior,Nothing}
            if ref !== nothing
                @test PosteriorDB.name(ref) isa String
                @test PosteriorDB.database(ref) === pdb
                @test PosteriorDB.info(ref) isa OrderedDict{String}
                @test isfile(PosteriorDB.path(ref))
                @test PosteriorDB.load(ref) isa Vector{<:OrderedDict{String}}
                @test PosteriorDB.load(ref, String) isa String
            end
        end
    end

    @testset "model" begin
        models = PosteriorDB.model_names(pdb)
        @test models isa Vector{String}
        @test !isempty(models)
        @testset "$n" for n in models
            mod = PosteriorDB.model(pdb, n)
            @test mod isa PosteriorDB.Model
            @test PosteriorDB.name(mod) == n
            @test PosteriorDB.database(mod) == pdb
            @test PosteriorDB.info(mod) isa OrderedDict{String}
            ppls = PosteriorDB.implementation_names(mod)
            @test ppls isa Vector{String}
            @test !isempty(ppls)
            @testset "$ppl" for ppl in ppls
                impl = PosteriorDB.implementation(mod, ppl)
                @test impl isa PosteriorDB.AbstractImplementation
                @test isfile(PosteriorDB.path(impl))
                @test PosteriorDB.load(impl) isa String
            end
        end
    end

    @testset "dataset" begin
        datasets = PosteriorDB.dataset_names(pdb)
        @test datasets isa Vector{String}
        @test !isempty(datasets)
        @testset "$n" for n in datasets
            data = PosteriorDB.dataset(pdb, n)
            @test data isa PosteriorDB.Dataset
            @test PosteriorDB.name(data) == n
            @test PosteriorDB.database(data) == pdb
            @test PosteriorDB.info(data) isa OrderedDict{String}
            @test isfile(PosteriorDB.path(data))
            @test PosteriorDB.load(data) isa OrderedDict{String}
            @test PosteriorDB.load(data, String) isa String
            @test PosteriorDB.format_json_data(
                JSON3.read(PosteriorDB.load(data, String))
            ) == PosteriorDB.load(data)
        end
    end
end
