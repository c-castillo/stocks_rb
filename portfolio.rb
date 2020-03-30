# frozen_string_literal: true
require 'csv'

class Portfolio
  def initialize(stocks)
    @stocks = stocks
  end

  def profit(start_date, end_date)
    total_profit = @stocks
                   .map { |s| s.price(end_date).to_i - s.price(start_date).to_i }
                   .reduce(:+)
    total_profit
  end
end

class Stock
  def initialize(symbol, history_file = 'stocks.csv')
    @symbol = symbol
    @history = load_history(history_file)
  end

  def load_history(file)
    table = CSV.parse(File.read(file), headers: true)
    stock_table = table.select { |k| k[0] == @symbol }
    stock_table
  end

  def price(date)
    csv_date = Date.parse(date).strftime('%b %-d %Y')
    stock_price = @history.select { |r| r[1] == csv_date }
    stock_price.flatten[5]
  end
end

stocks = [Stock.new('AAPL'), Stock.new('MSFT')]
portfolio = Portfolio.new(stocks)
puts portfolio.profit('2005-12-01', '2006-06-01')
