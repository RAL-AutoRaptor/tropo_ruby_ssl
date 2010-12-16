require 'java'
# if you are testing locally you may need to download and install 
# Apache Commons IO - http://commons.apache.org/io/
#
# This is already provided by the Tropo environment
#
# require 'commons-io-2.0/commons-io-2.0.jar'

module Net

  class HTTP
    remove_method :use_ssl?
    def use_ssl?; @use_ssl; end
    def use_ssl=(flag); @use_ssl=flag; end
        
    alias request_without_ssl request
    
    def request(req, body = nil, &block)
      return request(req, body, &block) unless use_ssl?
      url=java.net.URL.new("https://#{self.address}#{req.path}")
      conn = url.openConnection()
      # setup connection
      conn.setRequestMethod(req.method)
      req.each_header {|k,v| conn.setRequestProperty(k,v) }
      if body||=req.body
        conn.setDoOutput(true) 
        out=conn.getOutputStream
        pw=java.io.PrintWriter.new(out);
        pw.print(body)
        pw.flush
        pw.close
      end
      # get response
      httpv=conn.getHeaderField(0).match(/\AHTTP(?:\/(\d+\.\d+))?/)[1]
      code=conn.getResponseCode().to_s
      msg=conn.responseMessage      
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