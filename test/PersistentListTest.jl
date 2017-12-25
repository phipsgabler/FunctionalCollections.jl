using FunctionalCollections
using Base.Test

@testset "Persistent Lists" begin

    @testset "length" begin
        @test length(PersistentList([1])) == 1
        @test length(PersistentList([1, 2, 3])) == 3
        @test length(EmptyList()) == 0
    end

    @testset "equality" begin
        @test PersistentList(1:100) == PersistentList(1:100)
        @test PersistentList(1:100) != PersistentList(1:99)
        @test PersistentList(1:100) == collect(1:100)

        @test plist([]) == []
        @test plist([2]) != [1]
        @test plist([NaN])!= [NaN]

        @test isequal(plist([]), [])
        @test !isequal(plist([2]), [1])
        @test isequal(plist([NaN]), [NaN])
    end

    @testset "head" begin
        @test head(PersistentList(1:100)) == 1
        @test head(PersistentList([1]))   == 1
        @test try head(EmptyList()); false catch e true end
    end

    @testset "tail" begin
        @test tail(PersistentList(1:100)) == PersistentList(2:100)
        @test tail(PersistentList([1]))     == EmptyList()
        @test try tail(EmptyList()); false catch e true end
    end

    @testset "cons" begin
        @test cons(1, cons(2, cons(3, EmptyList()))) == PersistentList([1, 2, 3])
        @test 1..(2..(3..EmptyList())) == PersistentList([1, 2, 3])
    end

    @testset "sharing" begin
        l = PersistentList(1:100)
        l2 = 0..l
        @test l === tail(l2)
    end

    @testset "iteration" begin
        arr2 = Int[]
        for i in PersistentList(1:100)
            push!(arr2, i)
        end
        @test collect(1:100) == arr2
        @test collect(1:100) == collect(PersistentList(1:100))
    end

    @testset "indexing" begin
        l = PersistentList(1:10)
        @test all(l[i] == i for i in 1:10)
        @test l[end] == 10
    end

    @testset "map" begin
        @test map(x->x+1, PersistentList([1,2,3,4,5])) == PersistentList([2,3,4,5,6])
    end

    @testset "reverse" begin
        @test reverse(PersistentList(1:10)) == collect(10:-1:1)
    end

    @testset "hash" begin
        @test hash(PersistentList(1:1000)) == hash(PersistentList(1:1000))

        ls = Any[plist([]), plist([NaN]), plist([1,2,3]), plist([1,2,NaN]),
                 [], [NaN], [1,2,3], [1,2,NaN]]
        for a in ls, b in ls
            @test isequal(a, b) == (hash(a) == hash(b))
        end
    end

    @testset "isempty" begin
        @test isempty(EmptyList())
        @test !isempty(PersistentList([1]))
    end

end
