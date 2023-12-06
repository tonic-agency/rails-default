module Sms
  class Base
    require 'httparty'

    def send_message(mobile_number='', message='')
      return Rails.logger.warn("SMS is disabled, message to #{mobile_number} will not be send.") if disabled?
      
      url = 'https://rest.nexmo.com/sms/json'
      api_key = '063cd013'
      api_secret = 'hFS3BREksMbdbKXt'

      begin
        response = HTTParty.post(url, {
          body: {
            from: 'Farmbank',
            text: message,
            to: '34645614966',
            api_key: api_key,
            api_secret: api_secret
          }
        })
      
        # Check for successful response
        if response.success?
          puts "Request successful. Response: #{response.body}"
        else
          Rails.logger.error("HTTParty request failed. Response code: #{response.code}, Response body: #{response.body}")
        end
      
      rescue StandardError => e
        Rails.logger.error("An error occurred: #{e.message}")
      end
    end

    def disabled?
      !ENV.fetch("ENABLE_SMS")
    end

  end
end





