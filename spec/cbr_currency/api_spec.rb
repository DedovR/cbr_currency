require "spec_helper"

RSpec.describe CbrCurrency::Api do
  it "parse currencies" do
    doc = File.open('spec/files/response.xml', 'r').read
    expected_result = [
      {
        :char_code => "AUD",
        :convert_сoef => 42.0,
      },
      {
        :char_code => "AMD",
        :convert_сoef => 0.11,
      },
      {
        :char_code => "DKK",
        :convert_сoef => 8.5,
      }
    ]
    expect(CbrCurrency::Api.send(:parse_currencies, doc)).to eq expected_result
  end
end