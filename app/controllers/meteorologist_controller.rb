require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]
    url_safe_street_address = URI.encode(@street_address)

    # ==========================================================================
    # Your code goes below.
    # The street address the user input is in the string @street_address.
    # A URL-safe version of the street address, with spaces and other illegal
    #   characters removed, is in the string url_safe_street_address.
    # ==========================================================================

    require 'json'

    geo_root_url = "http://maps.googleapis.com/maps/api/geocode/json?address=" #Google Geocoding API
    geo_url = geo_root_url + "#{url_safe_street_address}"
    geo_parsed_data = JSON.parse(open(geo_url).read)

    @latitude = geo_parsed_data["results"][0]["geometry"]["location"]["lat"]

    @longitude = geo_parsed_data["results"][0]["geometry"]["location"]["lng"]

    forecast_root_url = "https://api.forecast.io/forecast/" #Dark Sky Forecast API

    forecast_api_key = "b28e5f6d98fdb3a90e04b3b22dd49fe4" #personal Forecast API key, user:michelle.oh@chicagobooth.edu

    forecast_url = forecast_root_url + forecast_api_key + "/#{@latitude},#{@longitude}"

    forecast_parsed_data = JSON.parse(open(forecast_url).read)

    @current_temperature = forecast_parsed_data["currently"]["temperature"]

    @current_summary = forecast_parsed_data["currently"]["summary"]

    @summary_of_next_sixty_minutes = forecast_parsed_data["minutely"]["summary"]

    @summary_of_next_several_hours = forecast_parsed_data["hourly"]["summary"]

    @summary_of_next_several_days = forecast_parsed_data["daily"]["summary"]

    render("street_to_weather.html.erb")
  end
end
