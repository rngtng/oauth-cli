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
    @options = options

    if options[:consumer_key].to_s.empty?
      color = 'YELLOW'
      say " <%= color('# -------------------------------------------------------------------------', #{color}) %>"
      say " <%= color('# no consumer_key provided, please create a profile or call the script with:', #{color}) %>"
      say " <%= color('# oauthc --consumer_key=<consumer_key> --consumer_secret=<consumer_secret>', #{color}) %>"
      say " <%= color('# -------------------------------------------------------------------------', #{color}) %>"
      #please get a key here: http://#{options[:host]}/api_consumers"
      return
    end
    
    #add http if missing
    [:host, :reg_host, :auth_host].each do |key|
      @options[key] = "http://#{@options[key]}" unless @options[key] =~ /^http/
    end
    
    @consumer     = OAuth::Consumer.new(@options[:consumer_key], @options[:consumer_secret], :site => @options[:host])
    @access_token = OAuth::AccessToken.new(@consumer, @options[:token], @options[:token_secret]) if @options[:token]
  end

  def request(method, uri, body = nil)
    if method =~ /auth/
      @request_token = @consumer.get_request_token({}, "oauth_callback" => "oob")
      @options[:auth_host] ||= "#{@options[:host].gsub('api.', 'www.').gsub('v1/', '')}/mobile/authorize?oauth_token=" #That's for Qype only!!
      color = 'YELLOW'
      say " <%= color('# To authorize, go to ...', #{color}) %>"
      say " <%= '#   ' + color('http://#{@options[:auth_host]}#{@request_token.token}', BOLD, UNDERLINE) %>\n"
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