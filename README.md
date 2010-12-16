Tropo Ruby SSL
==============

The Problem
-----------

Seems that Tropo doesn't support SSL very well for Ruby.  `require 'net/https'` and `use_ssl=true` does not work very well because they do not have the jruby-openssl gem in their environment.  If you read a few threads on their forums you will see that either they don't wish to install this gem, or their version of JRuby is too old to support it.  They suggest dropping down to the Java layer for the SSL connections.

That is just icky.


The Solution
------------

Write a drop in replacement for `net/https` that drops down to Java when `use_ssl=true` but hides all the ugly implimentation details from us.  `java.net.URLConnection` is used for all the heavy lifting:

<http://download.oracle.com/javase/6/docs/api/java/net/HttpURLConnection.html>


How to use it
-------------

Your tropo script should look like this:

	require 'net/http'
	# cut and paste the tropo_ssl.rb source here
	http=Net::HTTP.new("encrypted.google.com", 443)
	http.use_ssl=true

	req=Net::HTTP::Get.new("/")
	resp=http.request(req)
	log "Status: #{resp.code}"
	log "Headers: #{resp.to_hash.inspect}"
	log "Body: #{resp.body[0..50]}"

See example.rb for a full example example.

