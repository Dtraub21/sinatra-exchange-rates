require 'sinatra'
require 'sinatra/reloader' if development?
require 'http'
require 'json'

helpers do
  def fetch_data(url)
    response = HTTP.get(url)
    JSON.parse(response.to_s)
  end
end



get '/' do
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV['EXCHANGE_RATE_KEY']}"
  @data = fetch_data(api_url)

  erb :homepage
end

get '/:from_currency' do
  @original_currency = params['from_currency'].upcase
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV['EXCHANGE_RATE_KEY']}"
  @data = fetch_data(api_url)

  erb :currency
end

get '/:from_currency/:to_currency' do
  @from_currency = params['from_currency'].upcase
  @to_currency = params['to_currency'].upcase
  api_url = "https://api.exchangerate.host/convert?access_key=#{ENV['EXCHANGE_RATE_KEY']}&from=#{@from_currency}&to=#{@to_currency}&amount=1"
  @conversion_data = fetch_data(api_url)

  erb :conversion
end
