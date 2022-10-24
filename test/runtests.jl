using PosteriorDB
using Test

@testset "PosteriorDB.jl" begin
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
            @test info(post) isa AbstractDict
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
                @test info(ref) isa AbstractDict
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
            @test info(mod) isa AbstractDict
            ppls = implementation_names(mod)
            @test ppls isa Vector{String}
            @test !isempty(ppls)
            @testset "$ppl" for ppl in ppls
                # NOTE: eight_schools_centered for pymc3 missing from the latest release
                # of posteriordb even though the info indicates it is present
                n == "eight_schools_centered" && ppl == "pymc3" && continue
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
            @test info(data) isa AbstractDict
            @test load_values(data) isa AbstractDict
        end
    end
end
