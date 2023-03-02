@testset "Test NCUWiseLab, ARI_G2F820 data" begin
    ari0 = SWCDatasets.dataset("NCUWiseLab", "ARI_G2F820")
    d = pairs(eachcol(ari0))
    @test all(haskey.([d], (:year,:month,:day,:hour)))
end
