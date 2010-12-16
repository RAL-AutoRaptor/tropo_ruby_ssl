Tropo Ruby SSL
==============

The Problem
-----------

Seems that Tropo doesn't support SSL very well for Ruby.  `require 'net/https` and `use_ssl=true` does not work very well because they do not have the jruby-openssl gem in their environment.

If you read a few threads on their forums you will see that either they don't wish to install this gem, or their version of JRuby is too old to support it.  They suggest dropping down to the Java layer for the SSL connections.

And that is just icky.

The Solution
------------

Write a drop in replacement for `net/https`