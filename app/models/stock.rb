class Stock < ActiveRecord::Base
  #class level methods are defined here
  #We are adding the self. prior to the method name, because these methods are not tied to any objects or object lifecycle, we need to be able to use them without having any instances of a stock.

  #search in db instead of web
  def self.find_by_ticker(ticker_symbol)
    where(ticker: ticker_symbol).first
  end

  #StockQuote given by gem stockquote
  def self.new_from_lookup(ticker_symbol)
    looked_up_stock = StockQuote::Stock.quote(ticker_symbol)
    #return nil if invalid search is performed
    #this will avoid error
    return nil unless looked_up_stock.name

    #ticker and name created in migration
    new_stock = new(ticker: looked_up_stock.symbol, name: looked_up_stock.name)
    #last price from model generation of stock,
    new_stock.last_price = new_stock.price
    new_stock
  end

  #price for above
  def price
    closing_price = StockQuote::Stock.quote(ticker).close
    #if closing_price is not nil, will return closing_price
    return "#{closing_price} (Closing)" if closing_price
    #otherwise return opening price
    opening_price = StockQuote::Stock.quote(ticker).open
    return "#{opening_price} (Opening)" if opening_price
    #if the two above fails, return
    'Unavailable'
  end
end
