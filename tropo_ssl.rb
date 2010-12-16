require 'java'
require 'commons-io-2.0/commons-io-2.0.jar'

module Net

  class HTTP
    remove_method :use_ssl?
    def use_ssl?; @use_ssl; end
    def use_ssl=(flag); @use_ssl=flag; end
    
    def verify_mode; end
    
    alias connect_without_ssl connect
    alias request_without_ssl request
    
    def connect
      return connect_without_ssl unless use_ssl?
    end
    
    def request(req, body = nil, &block)
      return request(req, body, &block) unless use_ssl?
      # url=java.net.URL.new("https://#{self.address}#{req.path}")
      url=java.net.URL.new("http://raptor.local/")
      conn = url.openConnection()
      conn.setRequestMethod(req.method)
      code=conn.getResponseCode().to_s
      msg=conn.responseMessage
      httpv=conn.getHeaderField(0).match(/\AHTTP(?:\/(\d+\.\d+))?/)[1]
      resp=HTTPResponse.send(:response_class,code).new(httpv, code, msg)
      stm = conn.getInputStream 
      resp.instance_variable_set("@read", true)
      resp.instance_variable_set("@body", org.apache.commons.io.IOUtils.toString(stm) )
      stm.close
      conn.getHeaderFields.each do |k,v |
        next if k.nil?
        resp.add_field k, v.first
      end
      resp
    end
    
  end
end