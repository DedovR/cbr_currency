require "spec_helper"

RSpec.describe CbrCurrency::Cash do
  before(:all) do
    rates = {
      'RUB' => {convert_сoef: 1},
      'USD' => {convert_сoef: 57.002},
      'EUR' => {convert_сoef: 63.7852},
      'DKK' => {convert_сoef: 8.56902},
    }
    PStore.new(CbrCurrency::Rates::CACHE_KEY).transaction do |store|
      store[:rates]      = rates
      store[:updated_at] = Date.today
    end
  end

  it "convert RUB to USD" do
    my_cash = CbrCurrency::Cash.new(100)
    expect(my_cash.convert_to!('USD').amount).to eq 1.7543
  end

  it "convert USD to EUR" do
    my_cash = CbrCurrency::Cash.new(100, currency: 'USD')
    expect(my_cash.convert_to!('EUR').amount).to eq 89.3656
  end

  it "convert EUR to USD with 6 precision" do
    my_cash = CbrCurrency::Cash.new(50, currency: 'EUR', precision: 6)
    expect(my_cash.convert_to!('USD').amount).to eq 55.949967
  end

  it "converting_list" do
    my_cash = CbrCurrency::Cash.new(100, currency: 'EUR')
    result  = my_cash.converting_list(['EUR', 'DKK'])
    expect(result[0].currency_code).to eq 'EUR'
    expect(result[0].amount).to eq 100
    expect(result[1].currency_code).to eq 'DKK'
    expect(result[1].amount).to eq 744.3698
  end

  it "add" do
    rub_cash = CbrCurrency::Cash.new(100)
    usd_cash = CbrCurrency::Cash.new(100, currency: 'USD')
    expect((rub_cash + usd_cash).amount).to eq 5800.2
    expect(rub_cash.amount).to eq 100
    expect(rub_cash.currency_code).to eq 'RUB'
    expect(usd_cash.amount).to eq 100
    expect(usd_cash.currency_code).to eq 'USD'
  end

  it 'subtraction' do
    rub_cash = CbrCurrency::Cash.new(100)
    usd_cash = CbrCurrency::Cash.new(10, currency: 'EUR')
    expect((rub_cash - usd_cash).amount).to eq -537.852
    expect(rub_cash.amount).to eq 100
    expect(rub_cash.currency_code).to eq 'RUB'
    expect(usd_cash.amount).to eq 10
    expect(usd_cash.currency_code).to eq 'EUR'
  end
end