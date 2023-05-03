class CurrencyConversionRate
  def self.get_currency_rate(currency)
    uri = URI('https://api.apilayer.com/fixer/latest?base=INR&symbols=USD,EUR')

    req = Net::HTTP::Get.new(uri)
    req['apikey'] = "um7M9O55ZPPzpRHbdpxdHnWp8SdUSE6a"

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') { |http|
      http.request(req)
    }
    currency_rate = JSON.parse(res.body)["rates"][currency]
    if currency_rate==nil
      currency_rate = 1
    end
    currency_rate
  end
end