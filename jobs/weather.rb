require 'net/http'
require 'xmlsimple'

# Get a WOEID (Where On Earth ID)
# for your location from here:
# http://woeid.rosselliot.co.nz/
woe_id = 646099

# Temerature format:
# 'c' for Celcius
# 'f' for Fahrenheit
format = 'c'

SCHEDULER.every '15m', :first_in => 0 do |job|
  response = Net::HTTP.get('xml.weather.yahoo.com', "/forecastrss?w=#{woe_id}&u=#{format}") #via https://stackoverflow.com/a/36262971
  weather_data = XmlSimple.xml_in(response, { 'ForceArray' => false })['channel']['item']['condition']
  weather_location = XmlSimple.xml_in(response, { 'ForceArray' => false })['channel']['location']
  send_event('weather', { :temp => "#{weather_data['temp']}&deg;#{format.upcase}", :condition => weather_data['text'], :title => "#{weather_location['city']} Weather"})
end
