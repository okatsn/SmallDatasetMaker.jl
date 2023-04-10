@testset "difftable.jl" begin
    using DataFrames
    df1 = DataFrame(
        :a => randn(5),
        :b => randn(5),
        :c => randn(5),
    )

    df2 = DataFrame(
        :a => randn(7),
        :d => randn(7),
        :c => randn(7),
    )

    df3 = DataFrame(
        :a => randn(5),
        :b => randn(5),
        :d => randn(5),
        :e => randn(5),
    )

    dft = difftables(df1, df2, df3)
    @test isequal(dft.nrow, [5,7, 5])
    @test isequal(dft.ncol, [3,3, 4])
    @test isempty(dft.cols_add[1])
    @test isempty(dft.cols_lack[1])
    @test isequal(dft.cols_add[2], [:d])
    @test isequal(dft.cols_lack[2], [:b])
    @test isequal(dft.cols_add[3], [:d, :e])
    @test isequal(dft.cols_lack[3], [:c])
end
