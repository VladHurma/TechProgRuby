#encoding: utf-8

$LOAD_PATH.unshift('.')

require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do
	@db = SQLite3::Database.new 'db/family_money.db'
	@db.execute 'CREATE TABLE IF NOT EXISTS
		"Earnings"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"date" TEXT,
			"sourse" TEXT,
			"username" TEXT,
			"family_role" TEXT,
			"amount" INTEGER
		);'
end

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
	@how = params[:sourse]
	@username = params[:username]
	@num = params[:amount]
	@date = params[:date]
	@select = params[:family_role]

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
	@how = params[:sourse]
	@num = params[:amount]

	f = File.open 'public/payment.txt', "a"
	f.write "Z\n#{@date}\n#{@how}\n#{@username}\n#{@select}\n#{@num}\n"
	f.close

	r = File.open 'public/allpay.txt', "a"
	r.write "#{@num}\n"
	r.close

	erb :payment
end