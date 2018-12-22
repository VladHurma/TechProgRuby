# frozen_string_literal: true

require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require './lib/validator'
require './servises/servises'

def err_checker(page, params, block)
  @error = Validator.err_check page, params
  if @error != ''
    return erb page
  else
    block.call params
  end
end

configure do
  enable :sessions
  Servise.new.initialize_tables
end

helpers do
  def username
    session[:identity] || 'Hello, who are you?'
  end
end

before '*' do
  @servise = Servise.new
end

before '/secure/*' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = "Ты должен назвать себя, чтобы получить доступ к #{request.path}"
    halt erb(:log_in)
  end
end

get '/' do
  redirect to '/log_in'
end

get '/log_in' do
  erb :log_in
end

post '/log_in' do
  block = lambda do |params|
    session[:identity] = params[:username]
    where_user_came_from = session[:previous_url] || '/secure/table_of_family'

    redirect to '/secure/table_of_family'
  end

  err_checker :log_in, params, block
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
  @servise.destroy
  redirect to '/log_in'
end

get '/secure/table_of_family' do
  erb :table_of_family
end

post '/secure/table_of_family' do
  @login = params[:login]
  @password = params[:password]

  if @login == 'admin' && @password == 'secret'
    @table_content = {
      earn_content: [],
      fact_pay_content: [],
      planned_pay_content: [],
      sum_of_earnings: 0,
      sum_of_fact_payings: 0,
      sum_of_planned_payings: 0,
      result_money: 0
    }

    @servise.show @table_content

    @table_content[:result_money] = @table_content[:sum_of_earnings] - @table_content[:sum_of_fact_payings]

    erb :show_table_of_family
  else
    redirect to '/secure/table_of_family'
  end
end

get '/secure/earn' do
  erb :earn
end

post '/secure/earn' do
  block = lambda do |params|
    @servise.create_earning params
    erb :earn
  end

  err_checker :earn, params, block
end

get '/secure/fact_payment' do
  erb :fact_payment
end

post '/secure/fact_payment' do
  block = lambda do |params|
    @servise.create_fact_paying params
    erb :fact_payment
  end

  err_checker :fact_payment, params, block
end

get '/secure/planned_payment' do
  erb :planned_payment
end

post '/secure/planned_payment' do
  block = lambda do |params|
    @servise.create_planned_paying params
    erb :planned_payment
  end

  err_checker :planned_payment, params, block
end
