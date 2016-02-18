#!/usr/bin/env ruby

require 'rubygems'
require 'twitter'
require 'tzinfo'
require 'iconv'

credentials = {
  consumer_key:        ENV['TWITTER_CONSUMER_KEY'],
  consumer_secret:     ENV['TWITTER_CONSUMER_SECRET'],
  access_token:        ENV['TWITTER_ACCESS_TOKEN'],
  access_token_secret: ENV['TWITTER_ACCESS_TOKEN_SECRET']
}

local_months = [
  'janvāris', 'februāris', 'marts', 'aprīlis', 'maijs', 'jūnijs',
  'jūlijs', 'augusts', 'septembris', 'oktobris', 'novembris', 'decembris'
]

ic        = Iconv.new 'UTF-8//IGNORE', 'UTF-8'
name_data = JSON.parse ic.iconv(IO.read(File.dirname(__FILE__) + '/vardadienas.json'))

tz     = TZInfo::Timezone.get 'Europe/Riga'
time   = tz.utc_to_local Time.now.utc
names  = name_data[time.month.to_s][time.day.to_s].join(', ')
status = time.strftime('%_d. ') + local_months[time.month - 1] + ': ' +  names

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = credentials[:consumer_key]
  config.consumer_secret     = credentials[:consumer_secret]
  config.access_token        = credentials[:access_token]
  config.access_token_secret = credentials[:access_token_secret]
end

client.update status
STDOUT.puts status
