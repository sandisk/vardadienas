#!/usr/bin/env ruby

require 'rubygems'
require 'twitter'
require 'tzinfo'
require 'iconv'

credentials = {
  :consumer_key        => '',
  :consumer_secret     => '',
  :access_token        => '',
  :access_token_secret => ''
}

local_months = [
  'janvāris', 'februāris', 'marts', 'aprīlis', 'maijs', 'jūnijs',
  'jūlijs', 'augusts', 'septembris', 'oktobris', 'novembris', 'decembris'
]

ic        = Iconv.new 'UTF-8//IGNORE', 'UTF-8'
name_data = JSON.parse ic.iconv(IO.read(File.dirname(__FILE__) + '/vardadienas.json'))

tz        = TZInfo::Timezone.get 'Europe/Riga'
t         = tz.utc_to_local Time.now.utc
names     = name_data[t.month.to_s][t.day.to_s].join(', ')

status    = t.strftime('%_d. ') + local_months[t.month - 1] + ': ' +  names
status    += '.' if t.hour > 12 # Twitter doesn't like dupes and we post twice a day

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = credentials[:consumer_key]
  config.consumer_secret     = credentials[:consumer_secret]
  config.access_token        = credentials[:access_token]
  config.access_token_secret = credentials[:access_token_secret]
end

client.update status
STDOUT.puts status