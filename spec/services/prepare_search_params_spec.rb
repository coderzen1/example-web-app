require 'rails_helper'

RSpec.describe PrepareSearchParams do

  let(:params) do
    {
      q: {name_or_address_street_or_address_city_cont_any: ""}.with_indifferent_access
    }
  end



  it "should not create groupings" do
    query_params = PrepareSearchParams.new(params, 'name_or_address_street_or_address_city_cont_any').call

    expect(query_params[:combinator]).to eql('or')
    expect(query_params[:groupings]).to eql([])
  end

  it "should create one grouping" do

    params[:q][:name_or_address_street_or_address_city_cont_any] = "Location2"
    query_params = PrepareSearchParams.new(params, 'name_or_address_street_or_address_city_cont_any').call

    expect(query_params[:combinator]).to eql('or')
    expect(query_params[:groupings]).to eql([{"name_or_address_street_or_address_city_cont"=>"Location2"}])
  end

  it "should create two groupings" do

    params[:q][:name_or_address_street_or_address_city_cont_any] = "Location2 strojarska"
    query_params = PrepareSearchParams.new(params, 'name_or_address_street_or_address_city_cont_any').call

    expect(query_params[:combinator]).to eql('or')
    expect(query_params[:groupings]).to eql([{"name_or_address_street_or_address_city_cont"=>"Location2"}, {"name_or_address_street_or_address_city_cont"=>"strojarska"}])
  end
end
