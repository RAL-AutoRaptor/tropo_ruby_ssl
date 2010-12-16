require 'net/http'
require 'net/https'

http=Net::HTTP.new("encrypted.google.com", 443)
http.use_ssl=true

req=Net::HTTP::Get.new("/")
resp=http.request(req)
puts "Status: #{resp.code}"
puts "Headers: #{resp.to_hash.inspect}"
puts "Body: #{resp.body[0..50]}"

