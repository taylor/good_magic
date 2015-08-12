#!/usr/bin/env ruby

require 'net/http'
require 'openssl'
require 'fileutils'

require './decks.rb'

if ENV['RUN_SINGLE'] == "true"
  decks = [SINGLE]
else
  decks = [MORIGINS, DRAGONS, FATE, KHANS, M15, JOURNEY, BORN, THEROS]
end

decks.each{ |deck|

  cards = deck
  results = []

  #sets name of deck in the API call
  if deck == MORIGINS then
    deck_title = "Magic Origins"
  elsif deck == DRAGONS then
    deck_title = "Dragons of Tarkir"
  elsif deck == FATE then
    deck_title = "Fate Reforged"
  elsif deck == KHANS then
    deck_title = "Khans of Tarkir"
  elsif deck == M15 then
    deck_title = "Magic 2015 (M15)"
  elsif deck == JOURNEY then
    deck_title = "Journey into Nyx"
  elsif deck == BORN then
    deck_title = "Born of the Gods"
  else deck_title = "Theros"
  end

 if deck == SINGLE then
    deck_title = "Magic Origins"
 end


  #pulls the API info for each card
 deck.each{|card|
   uri = URI.parse("http://partner.tcgplayer.com/x3/phl.asmx/p")
   params = { :pk => ENV['TCGPLAYER_PARTNER_KEY'], :p => card, :s => deck_title}
   uri.query = URI.encode_www_form(params)
   http = Net::HTTP.new(uri.host, uri.port)

   http.verify_mode = OpenSSL::SSL::VERIFY_NONE
   request = Net::HTTP::Get.new(uri.request_uri)

   response = http.request(request)

   #stores the response in an array
   results << [card, response.body]
   puts card
   puts response.body
 }

 unless Dir.exist?('output')
   FileUtils.mkdir('output')
 end

 #creates new file with deck name and date
 File.open("output/#{deck_title}_#{Time.now.month}_#{Time.now.day}_#{Time.now.year}.xml", "w") do |f|
   results.each{|record| f.puts "#{record.first}\n#{record.last}" }
 end
}
