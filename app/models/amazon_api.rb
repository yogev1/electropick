class AmazonApi < ApplicationRecord
  require 'openssl'
  ENDPOINT = "webservices.amazon.com"
  REQUEST_URI = "/onca/xml"

	def generate_request_url(params)
		params["Timestamp"] = Time.now.gmtime.iso8601 if !params.key?("Timestamp")
    canonical_query_string = params.sort.collect do |key,value|
      [URI.escape(key.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")), 
       URI.escape(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))].join('=')
    end.join('&')
    string_to_sign = "GET\n#{ENDPOINT}\n#{REQUEST_URI}\n#{canonical_query_string}"
    signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), 
      ENV["AWS_SECRET_KEY"], string_to_sign)).strip()
    request_url = "http://#{ENDPOINT}#{REQUEST_URI}?#{canonical_query_string}&Signature=#{URI.escape(signature,
      Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}"     
	end

  def by_keyword(keywords)
    params = {
      "Service" => "AWSECommerceService",
      "Operation" => "ItemSearch",
      "AWSAccessKeyId" => ENV["AWS_ACCESS_KEY_ID"],
      "AssociateTag" => ENV["AWS_ASSOCIATES_TAG"],
      "SearchIndex" => "All",
      "Keywords" => keywords,
      "ResponseGroup" => "Images,Offers,Small"
    }
    generate_request_url(params)
  end

  def by_asin(asin)
    params = {
      "Service" => "AWSECommerceService",
      "Operation" => "ItemLookup",
      "AWSAccessKeyId" => ENV["AWS_ACCESS_KEY_ID"],
      "AssociateTag" => ENV["AWS_ASSOCIATES_TAG"],
      "ItemId" => "asin",
      "IdType" => "ASIN",
      "Keywords" => keywords,
      "ResponseGroup" => "Images,Offers,Small",
      "Condition" => "New"
    }
    generate_request_url(params)
  end

  def by_keyword_and_category(keywords,category)
    params = {
      "Service" => "AWSECommerceService",
      "Operation" => "ItemSearch",
      "AWSAccessKeyId" => ENV["AWS_ACCESS_KEY_ID"],
      "AssociateTag" => ENV["AWS_ASSOCIATES_TAG"],
      "SearchIndex" => category,
      "Keywords" => keywords,
      "ResponseGroup" => "Images,Offers,Small"
    }
    generate_request_url(params)
  end  

  def by_asin_for_similar_items(asin)
    params = {
      "Service" => "AWSECommerceService",
      "Operation" => "ItemSearch",
      "AWSAccessKeyId" => ENV["AWS_ACCESS_KEY_ID"],
      "AssociateTag" => ENV["AWS_ASSOCIATES_TAG"],
      "ItemId" => asin,
      "MerchantId" => "Amazon",
      "ResponseGroup" => "Images,Offers,Small",
      "SimilarityType" => "Intersection"      
    }
    generate_request_url(params)
  end

  def show_string(string,size)
    string = string.split(/\W+/).slice(0,size-1).join(' ')
  end 
end
