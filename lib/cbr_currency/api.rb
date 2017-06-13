require 'net/http'
require 'uri'
require 'ox'

module CbrCurrency
  class Api
    DAILY_CURRENCIES = "http://www.cbr.ru/scripts/xml_daily.asp?date_req=%{date}"

    class << self
      def get_currencies
        response = Net::HTTP.get(URI(DAILY_CURRENCIES % {date: format_date(Date.today)}))
        parse_currencies(response)
      end

      private

      def parse_currencies(data)
        xml    = Ox.parse(data)
        result = []
        xml.locate('ValCurs/Valute').each do |t|
          nominal = t.Nominal.text.to_i
          value   = t.Value.text.to_f
          next if 0 == nominal
          result << {
            char_code: t.CharCode.text,
            convert_сoef: value / nominal,
          }
        end
        result
      end

      def format_date(date)
        date.strftime("%d.%m.%Y")
      end
    end
  end
end