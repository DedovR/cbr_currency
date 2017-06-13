require 'pstore'

module CbrCurrency
  class Rates
    DEFAULT_RATES = {
      'RUB' => {
        convert_сoef: 1,
      }
    }
    CACHE_KEY = 'rates.pstore'
    @@rates   = DEFAULT_RATES

    class << self
      def get_currency(currency_code)
        rate = get_rate(currency_code)
        raise "Undefined currency code" if rate.nil?
        CbrCurrency::Currency.new(currency_code, rate)
      end

      def get_rate(currency_code)
        rates_preload
        rate = @@rates[currency_code]
        if rate.nil?
          load_rates
          rate = @@rates[currency_code]
        end
        rate
      end

      private

      def rates_preload
        store      = PStore.new(CACHE_KEY)
        updated_at = store.transaction{ store.fetch(:updated_at, nil) }
        return if updated_at.nil?

        if Date.today != updated_at
          @@rates = DEFAULT_RATES
        else
          @@rates = store.transaction{ store.fetch(:rates, DEFAULT_RATES) }
        end
      end

      def load_rates
        currencies = CbrCurrency::Api.get_currencies
        @@rates    = DEFAULT_RATES
        currencies.each do |cur|
          code = cur[:char_code]
          cur.delete(:char_code)
          @@rates[code] = cur
        end
        return if DEFAULT_RATES == @@rates

        PStore.new(CACHE_KEY).transaction do |store|
          store[:rates]      = @@rates
          store[:updated_at] = Date.today
        end
      end
    end
  end
end