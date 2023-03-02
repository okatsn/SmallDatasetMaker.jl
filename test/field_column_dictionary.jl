@testset "field_column_dictionary" begin
    @test isequal.(
        keys(SmallDatasetMaker.field_column_dictionary),
        values(SmallDatasetMaker.column_field_dictionary)
    ) |> all

    @test isequal.(
        values(SmallDatasetMaker.field_column_dictionary),
        keys(SmallDatasetMaker.column_field_dictionary)
    ) |> all
end