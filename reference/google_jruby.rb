require 'java'
require 'commons-io-2.0/commons-io-2.0.jar'

svcURL = "https://encrypted.google.com/"; 
url= java.net.URL.new svcURL 
# conn = java.net.HttpURLConnection.new(url)
conn = url.openConnection()
stm = conn.getInputStream 
body = org.apache.commons.io.IOUtils.toString(stm) 
stm.close

headers=conn.getHeaderFields().inject(Hash.new) { |sum,n | sum[n[0]]=n[1].to_s; sum  }
puts "Status: #{conn.getResponseCode}"
puts "Body: #{body[0..50]}"
puts "Headers: #{headers.inspect}"