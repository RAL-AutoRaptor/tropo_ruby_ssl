require 'net/http'
require 'tropo_ssl'

http=Net::HTTP.new("encrypted.google.com", 443)
http.use_ssl=true

req=Net::HTTP::Get.new("/")
resp=http.request(req)
puts "Status: #{resp.code}"
puts "Version: #{resp.http_version}"
puts "Headers: #{resp.to_hash.inspect}"
puts "Body: #{resp.body[0..50]}"