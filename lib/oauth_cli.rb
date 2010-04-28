require 'highline/import'
require 'oauth'
require 'json'

begin
  require 'ap' #try to load awesome_print for nice json output
rescue LoadError
end

HighLine.track_eof = false #hotfix to make highline work

class OauthCli

  attr_reader :options
  
  def initialize(options = {})
    @options = {}
    connect(options)
  end
  
  def connect(options = {})
    return false unless options
    options.each { |key, value| @options[key.to_sym] = value }

    #add http if missing
    [:host, :reg_url, :auth_url].each do |key|
      @options[key] = "http://#{@options[key]}" unless @options[key] =~ /^http/
    end
    
    @consumer     = OAuth::Consumer.new(@options[:consumer_key], @options[:consumer_secret], :site => @options[:host])
    # :request_token_path => "/oauth/example/request_token.php",
    # :access_token_path  => "/oauth/example/access_token.php",
    # :authorize_path     => "/oauth/example/authorize.php"
    
    @access_token = OAuth::AccessToken.new(@consumer, @options[:token], @options[:token_secret]) if @options[:token]
  end

  def connected?
    @options[:consumer_key] && @options[:consumer_secret] && @options[:host]
  end

  def self.parse_args(args, opt = {}, last_arg = nil)
    method, uri, body  = args.clone.delete_if do |kv|
      next opt[$1.to_sym] = $2  if kv =~ /-?-([^=]+)=(.+)$/   #catches --param=value
      next opt[last_arg] = kv   if last_arg && !opt[last_arg] #catches value
      next last_arg = $1.to_sym if kv =~ /^-?-(.+)$/          #catches --param
      false
    end
    [method, uri, body, opt, (opt.delete(:profile) || opt.delete(:p))]
  end

  def request(method, uri, body = nil)
    if method =~ /auth/
      @request_token = @consumer.get_request_token({}, "oauth_callback" => "oob")
      @options[:auth_url] ||= "#{@options[:host].gsub('api.', 'www.').gsub('v1/', '')}/mobile/authorize" #That's for Qype only!!
      color = 'YELLOW'
      say " <%= color('# To authorize, go to ...', #{color}) %>"
      say " <%= '#   ' + color('#{@options[:auth_url]}?oauth_token=#{@request_token.token}', BOLD, UNDERLINE) %>\n"
      say " <%= color('#  ... and enter given token verifier:', #{color}) %>"
      verifier = ask " |-- verifier >> "

      begin
        @access_token = @request_token.get_access_token({}, "oauth_verifier" => verifier)

        @options[:token] = @access_token.token
        @options[:token_secret] = @access_token.secret

        color = 'GREEN'
        say " <%= color('# -------------------------------------------------------------------------', #{color}) %>"
        say " <%= color('# Authorization SUCCESSFUL', BOLD, #{color}) %>"
        say " <%= color('# -------------------------------------------------------------------------', #{color}) %>"
        say " <%= color(' token:        #{@access_token.token}', #{color}) %>"
        say " <%= color(' token_secret: #{@access_token.secret}', #{color}) %>"
      rescue
        color = 'RED'
        say " <%= color('# -------------------------------------------------------------------------', #{color}) %>"
        say " <%= color('# Authorization FAILED', BOLD, #{color}) %>"
        say " <%= color('# -------------------------------------------------------------------------', #{color}) %>"
      end
      return
    end

    unless %w(get post put delete).include? method.to_s
      color = 'RED'
      say " <%= color('# -------------------------------------------------------------------------', #{color}) %>"
      say " <%= color('# Wrong HTTP Method: #{method}  - calling #{@options[:host]}#{uri}', BOLD, #{color}) %>"
      say " <%= color('# -------------------------------------------------------------------------', #{color}) %>"
      return
    end

    uri  = ask " |-- request uri >> " if !uri
    body = ask " |-- request body >> " if !body && (method == "post" || method == "put")
    
    url = @options[:host] + uri

    @options[:mime_type]    ||= (url =~ /\.json/) ? "application/json" : "application/xml"
    @options[:content_type] ||= (url =~ /\.json/) ? "application/json" : "application/xml"

    response = @consumer.request(method, url, @access_token, {}, body, { 'Accept' => @options[:mime_type], 'Content-Type' => @options[:content_type] })

    header = response.header

    color = (response.code.to_i < 400) ? 'GREEN' : 'RED'
    say " <%= color('# -------------------------------------------------------------------------', #{color}) %>"
    say " <%= color('# Status: #{header.code} #{header.message}  - calling #{@options[:host]}#{uri}', BOLD, #{color}) %>"
    say " <%= color('# -------------------------------------------------------------------------', #{color}) %>"

    body = response.body
    if header.content_type =~ /json/
      body = JSON.parse(body)
      ap(body) rescue say(JSON.pretty_generate(body))
      return
    end

    body = " <%= color('# #{$1.gsub("'", "")} ', RED) %>" if body =~ /<pre>(.+)<\/pre>/
    say body
  end

end