# frozen_string_literal: true

class Servise
  def initialize
    @db = SQLite3::Database.new 'db/family_money.db'
  end

  def initialize_tables
    @db.execute 'CREATE TABLE IF NOT EXISTS
			"Earnings"
			(
				"id" INTEGER PRIMARY KEY AUTOINCREMENT,
				"date" TEXT,
				"sourse" TEXT,
				"username" TEXT,
				"family_role" TEXT,
				"placeholder_of_earning" TEXT,
				"amount" INTEGER
			)'
    @db.execute 'CREATE TABLE IF NOT EXISTS
			"Fact_payings"
			(
				"id" INTEGER PRIMARY KEY AUTOINCREMENT,
				"date" TEXT,
				"sourse" TEXT,
				"username" TEXT,
				"amount" INTEGER
			)'
    @db.execute 'CREATE TABLE IF NOT EXISTS
			"Planned_payings"
			(
				"id" INTEGER PRIMARY KEY AUTOINCREMENT,
				"sourse" TEXT,
				"amount" INTEGER
			)'
  end

  def create_earning(params)
    @db.execute 'INSERT INTO
			Earnings (date, sourse, username, family_role, placeholder_of_earning,amount)
			values (?, ?, ?, ?, ?, ?)', [params[:date], params[:sourse], params[:username], params[:family_role], params[:placeholder_of_earning], params[:amount]]
  end

  def create_fact_paying(params)
    @db.execute 'INSERT INTO
			Fact_payings (date, sourse, username, amount)
			values (?, ?, ?, ?)', [params[:date], params[:sourse], params[:username], params[:amount]]
  end

  def create_planned_paying(params)
    @db.execute 'INSERT INTO
			Planned_payings (sourse, amount)
			values (?, ?)', [params[:sourse], params[:amount]]
  end

  def show(table_content)
    @db.execute 'SELECT * FROM Earnings' do |row|
      table_content[:earn_content] << row
    end
    @db.execute 'SELECT * FROM Fact_payings' do |row|
      table_content[:fact_pay_content] << row
    end
    @db.execute 'SELECT * FROM Planned_payings' do |row|
      table_content[:planned_pay_content] << row
    end
    @db.execute 'SELECT amount FROM Earnings' do |amount|
      table_content[:sum_of_earnings] += amount[0]
    end
    @db.execute 'SELECT amount FROM Fact_payings' do |amount|
      table_content[:sum_of_fact_payings] += amount[0]
    end
    @db.execute 'SELECT amount FROM Planned_payings' do |amount|
      table_content[:sum_of_planned_payings] += amount[0]
    end
  end

  def destroy
    @db.execute 'DROP TABLE Earnings'
    @db.execute 'DROP TABLE Fact_payings'
    @db.execute 'DROP TABLE Planned_payings'
  end
end
