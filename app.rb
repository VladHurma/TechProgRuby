#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
	erb :admin
end

post '/' do
	@login = params[:login]
	@password = params[:password]

	if @login == "admin" && @password == "secret"
		@earnfile = File.read("public/earn.txt")
		@paymentfile = File.read("public/payment.txt")
		@allearn = File.read("public/allearn.txt")
		@allpay = File.read("public/allpay.txt")
		erb :showTable
    else
		redirect to "/"
	end
			
end


get '/earn' do
	erb :earn
end

post '/earn' do	
	@how = params[:how]
	@username = params[:username]
	@num = params[:num]
	@date = params[:date]
	@select = params[:select]

	f = File.open 'public/earn.txt', "a"
	f.write "Z\n#{@date}\n#{@how}\n#{@username}\n#{@select}\n#{@num}\n"
	f.close

	r = File.open 'public/allearn.txt', "a"
	r.write "#{@num}\n"
	r.close

	erb :earn
end


get '/payment' do
	erb :payment
end

post '/payment' do	
	@how = params[:how]
	@num = params[:num]

	f = File.open 'public/payment.txt', "a"
	f.write "Z\n#{@date}\n#{@how}\n#{@username}\n#{@select}\n#{@num}\n"
	f.close

	r = File.open 'public/allpay.txt', "a"
	r.write "#{@num}\n"
	r.close

	erb :payment
end