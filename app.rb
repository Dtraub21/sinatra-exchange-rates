require 'sinatra'
require 'sinatra/reloader' if development?
require 'http'
require 'json'

# Route for the homepage listing all currencies
get '/' do
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV['EXCHANGE_RATE_KEY']}"
  response = HTTP.get(api_url)
  @currencies = JSON.parse(response.body.to_s)['symbols']
  erb :index
end

# Route for a specific currency showing conversion links to all other currencies
get '/:from_currency' do
  @from_currency = params['from_currency'].upcase
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV['EXCHANGE_RATE_KEY']}"
  response = HTTP.get(api_url)
  @currencies = JSON.parse(response.body.to_s)['symbols']
  erb :currency
end

# Route for converting from one specific currency to another
get '/:from_currency/:to_currency' do
  @from_currency = params['from_currency'].upcase
  @to_currency = params['to_currency'].upcase
  api_url = "https://api.exchangerate.host/convert?access_key=#{ENV['EXCHANGE_RATE_KEY']}&from=#{@from_currency}&to=#{@to_currency}&amount=1"
  response = HTTP.get(api_url)
  @result = JSON.parse(response.body.to_s)['result']
  erb :conversion
end
