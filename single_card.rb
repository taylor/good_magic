#!/usr/bin/env ruby
require 'net/http'


uri = URI.parse("http://partner.tcgplayer.com/x3/phl.asmx/p")
params = { :pk => ENV['TCGPLAYER_PARTNER_KEY'], :p => "Urborg, Tomb of Yawgmoth", :s => "Magic 2015 (M15)"}
uri.query = URI.encode_www_form(params)
http = Net::HTTP.new(uri.host, uri.port)

http.verify_mode = OpenSSL::SSL::VERIFY_NONE
request = Net::HTTP::Get.new(uri.request_uri)

response = http.request(request)

puts response.body
