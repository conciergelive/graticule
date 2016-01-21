# encoding: UTF-8
require 'test_helper'

module Graticule
  module Geocoder
    class FreeGeoIpTest < Test::Unit::TestCase

      def setup
        @geocoder = FreeGeoIp.new
        URI::HTTP.responses = []
        URI::HTTP.uris = []
      end

      def test_success
        prepare_response :success

        location = Location.new :country => 'Canada', :locality => 'Toronto',
          :region => 'Ontario', :postal_code => 'M5J', :latitude => 43.6329, :longitude => -79.3611

        assert_equal location, @geocoder.locate('162.219.176.3')
      end

      def test_unknown
        prepare_response :not_found
        assert_raises(AddressError) { @geocoder.locate('127.0.0.1') }
      end

      def test_private_ip
        prepare_response :private
        assert_raises(AddressError) { @geocoder.locate('127.0.0.1') }
      end

    private

      def prepare_response(id = :success)
        URI::HTTP.responses << response('free_geo_ip', id, 'json')
      end

    end
  end
end