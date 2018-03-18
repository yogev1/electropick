class PagesController < ApplicationController
  def index
    # supplying keywords
    keywords = "samsung galaxy"

    # making request to amazon API
    @search = AmazonApi.new
    url = @search.by_keyword(keywords)
    @results = HTTParty.get(url)
    @items_hash = @results["ItemSearchResponse"]["Items"]["Item"]



    client = ApiAiRuby::Client.new(
      :client_access_token => 'AWS_ACCESS_KEY_ID'
    ) 
    

  end
end
