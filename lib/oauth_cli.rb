require 'highline/import'
require 'oauth'
require 'json'

CFG_FILE = File.expand_path('~/.oauthconfig') 
HighLine.track_eof = false #hotfix to make highline work

class OauthCli
  def self.main(params, opt = {})
    #parse CLI input
    method, uri, body = params.delete_if do |kv|
      next opt[$1.to_sym] = $2 if kv =~ /-?-([^=]+)=(.+)$/
      false
    end
    body = ask ">> request body:" if body.to_s.empty? && (method == "post" || method == "put")
    opt[:profile] ||= opt[:p] #shortcut for profile
    
    #load external config if profile given
    if opt[:profile] && File.exists?(CFG_FILE)
      cfg_options =  YAML.load_file(CFG_FILE)
      opt = symbolize_keys(cfg_options[opt[:profile]]) if cfg_options[opt[:profile]]
    end

    if opt[:h] || opt[:help] || method.to_s.empty? || uri.to_s.empty?
      say " <%= color('#  ERROR: please provide method and uri', RED) %>" if method.to_s.empty? || uri.to_s.empty?
      say "Usage:"
      say "[repl] oauthc [options] <method> <uri> [<body>]"
      say "options are:"
      say "profile: --profile=<profile> -> put a .yml file to ~/.oauthconfig"
      say "--host=<host> --consumer_key=<consumer_key> --consumer_secret=<consumer_secret> --token=<token> --token_secret=<token_secret>"
      return
    end
    
    response = execute(method, uri, body, opt)
    
    header = response.header
    color = (response.code.to_i < 400) ? 'GREEN' : 'RED' 
    say " <%= color('# -------------------------------------------------------------------------', #{color}) %>"
    say " <%= color('# Status: #{header.code} #{header.message}  - calling #{opt[:host]}#{uri}', BOLD, #{color}) %>"
    say " <%= color('# -------------------------------------------------------------------------', #{color}) %>"
  
    body = response.body
    body = " <%= color('# #{$1.gsub("'", "")} ', RED) %>" if body =~ /<pre>(.+)<\/pre>/  
    body = JSON.pretty_generate(JSON.parse(body)) if uri =~ /.json/  rescue ''
    say body
  end
  
  def self.execute(method, uri, body, options)
    if options[:consumer_key].to_s.empty?
      color = 'YELLOW' 
      say " <%= color('# -------------------------------------------------------------------------', #{color}) %>"
      say " <%= color('# no consumer_key provided, call the script with:', #{color}) %>"
      say " <%= color('# oauthc --consumer_key=<consumer_key> --consumer_secret=<consumer_secret>', #{color}) %>"
      say " <%= color('# -------------------------------------------------------------------------', #{color}) %>"
      #please get a key here: http://#{options[:host]}/api_consumers"
      exit
    end
    
    @consumer = OAuth::Consumer.new(options[:consumer_key], options[:consumer_secret], :site => "http://#{options[:host]}")
    
    if options[:token]
      @access_token = OAuth::AccessToken.new(@consumer, options[:token], options[:token_secret])
    elsif !options[:read_only]
      #say "To authorize, go to:\n  <%= color('http://#{options[:host].gsub('api.', 'www.')}/mobile/authorize?oauth_token=#{@request_token.token}', BOLD, UNDERLINE) %>\n\n"

      @request_token = @consumer.get_request_token({}, "oauth_callback" => "oob")
      color = 'YELLOW' 
      say " <%= color('# -------------------------------------------------------------------------', #{color}) %>"
      say " <%= color('# no access token found please provide verifier to for tokens:', #{color}) %>"
      verifier = ask ">>"
      
      @access_token = @request_token.get_access_token({}, "oauth_verifier" => verifier)         
      say " <%= color('# all done, recall the script with:', #{color}) %>"  
      say " <%= color('# oauthc --consumer_key=#{options[:consumer_key]} --consumer_secret=#{options[:consumer_secret]} --token=#{@consumer.token} --token_secret=#{@consumer.secret}', #{color}) %>"      
      say " <%= color('# -------------------------------------------------------------------------', #{color}) %>"            
      exit
    end
    
    url = "http://#{options[:host]}#{uri}"
    
    mime_type = (url =~ /\.json/) ? "application/json" : "application/xml"
    @consumer.request(method, url, @access_token, {}, body, { 'Accept' => mime_type, 'Content-Type' => mime_type })
  end
    
  def self.symbolize_keys(hash)
    new_hash = {}
    hash.each { |key, value| new_hash[key.to_sym] = value }  
    new_hash
  end
end