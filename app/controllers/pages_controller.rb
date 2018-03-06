class PagesController < ApplicationController
  def index
    # supplying keywords
    keywords = "samsung galaxy s 8"

    # making request to amazon API
    @search = AmazonApi.new
    url = @search.by_keyword(keywords)
    @results = HTTParty.get(url)
    @items_hash = @results["ItemSearchResponse"]["Items"]["Item"]    
  end
end
