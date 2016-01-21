# encoding: UTF-8
require 'yaml'

module Graticule #:nodoc:
  module Geocoder #:nodoc:

    class FreeGeoIp < Base
      URL_TEMPLATE = 'http://freegeoip.net/json/%{ip_address}'
      
      def initialize
      end

      def locate(ip_address)
        @url = URI.parse(URL_TEMPLATE % { ip_address: ip_address })
        get
      end

    private

      def prepare_response(response)
        begin
          JSON.parse(response)
        rescue JSON::ParserError
          return {}
        end
      end

      def parse_response(response) #:nodoc:
        #{"ip":"162.219.176.3","country_code":"CA","country_name":"Canada","region_code":"ON","region_name":"Ontario","city":"Toronto","zip_code":"M5J","time_zone":"America/Toronto","latitude":43.6329,"longitude":-79.3611,"metro_code":0}
        Location.new.tap do |location|
          location.latitude = response['latitude']
          location.longitude = response['longitude']
          location.locality = response['city']
          location.country = response['country_name']
          location.region = response['region_name']
          location.postal_code = response['zip_code']
        end
      end

      def check_error(response) #:nodoc:
      end

    end
  end
end