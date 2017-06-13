module CbrCurrency
  class Cash
    attr_accessor :amount, :precision
    attr_reader   :currency

    def initialize(amount, currency: "RUB", precision: 4)
      @amount    = amount
      @currency  = CbrCurrency::Currency == currency.class ? currency : find_currency(currency)
      @precision = precision
    end

    def convert_to!(currency_code)
      to_currency = find_currency(currency_code)
      return self if to_currency.code == self.currency_code

      raise if 0 == to_currency.convert_сoef
      @amount   = (@amount * @currency.convert_сoef / to_currency.convert_сoef).round(@precision)
      @currency = to_currency
      self
    end

    def converting_list(currency_codes = [])
      result = []
      currency_codes.each do |code|
        cash = CbrCurrency::Cash.new(@amount, currency: @currency, precision: @precision)
        result << cash.convert_to!(code)
      end
      result
    end

    def currency_code
      @currency.code
    end

    def + (cash)
      dup_cash = cash.clone
      dup_cash.convert_to!(currency_code)
      CbrCurrency::Cash.new(@amount + dup_cash.amount, currency: @currency, precision: @precision)
    end

    def - (cash)
      dup_cash = cash.clone
      dup_cash.convert_to!(currency_code)
      CbrCurrency::Cash.new(@amount - dup_cash.amount, currency: @currency, precision: @precision)
    end

    private

    def find_currency(currency_code)
      CbrCurrency::Rates.get_currency(currency_code)
    end
  end
end