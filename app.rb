#encoding: utf-8

require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
	return SQLite3::Database.new 'db/family_money.db'
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS
		"Earnings"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"date" TEXT,
			"sourse" TEXT,
			"username" TEXT,
			"family_role" TEXT,
			"amount" INTEGER
		)'
	db.execute 'CREATE TABLE IF NOT EXISTS
		"Payings"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"sourse" TEXT,
			"amount" INTEGER
		)'
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

	db = get_db
	db.execute 'INSERT INTO
	Earnings (date, sourse, username, family_role, amount)
	values (?, ?, ?, ?, ?)', [params[:date], params[:sourse], params[:username], params[:family_role], params[:amount]]

	erb :earn
end


get '/payment' do
	erb :payment
end

post '/payment' do	

	db = get_db
	db.execute 'INSERT INTO
	Payings (sourse, amount)
	values (?, ?)', [params[:sourse], params[:amount]]

	erb :payment
end