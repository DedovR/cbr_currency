require "spec_helper"

RSpec.describe CbrCurrency::Rates do
  it "get currency from :@@rates" do
    CbrCurrency::Rates.class_variable_set(:@@rates, CbrCurrency::Rates::DEFAULT_RATES)
    currency = CbrCurrency::Rates.get_currency('RUB')
    expect(currency.code).to eq 'RUB'
    expect(currency.convert_сoef).to eq 1
  end

  it "get currency from cache" do
    PStore.new(CbrCurrency::Rates::CACHE_KEY).transaction do |store|
      store[:rates]      = {'RUB' => {convert_сoef: 1}, 'USD' => {convert_сoef: 55}}
      store[:updated_at] = Date.today
    end
    currency = CbrCurrency::Rates.get_currency('USD')
    expect(currency.code).to eq 'USD'
    expect(currency.convert_сoef).to eq 55
  end

  it "get currency from api" do
    CbrCurrency::Rates.class_variable_set(:@@rates, CbrCurrency::Rates::DEFAULT_RATES)
    PStore.new(CbrCurrency::Rates::CACHE_KEY).transaction do |store|
      store[:rates]      = {'RUB' => {convert_сoef: 1}, 'USD' => {convert_сoef: 55}}
      store[:updated_at] = Date.today - 1
    end
    allow(CbrCurrency::Api).to receive(:get_currencies).and_return([{char_code: 'USD', convert_сoef: 56}])
    currency = CbrCurrency::Rates.get_currency('USD')
    expect(currency.code).to eq 'USD'
    expect(currency.convert_сoef).to eq 56
  end
end