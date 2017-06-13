module CbrCurrency
  class Currency
    attr_reader :code, :convert_сoef

    def initialize(code, convert_сoef: 1)
      @code         = code
      @convert_сoef = convert_сoef
    end
  end
end