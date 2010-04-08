#!/usr/bin/env ruby

require 'rubygems'
require 'pp'
require 'highline/import'
require 'oauth'
require 'json'

HighLine.track_eof = false #hotfix to make highline work

###########
# a simple command line oauth test client
# run me with:  
# [repl] lib/oauth_test_client.rb [options] <method> <uri> [<body>]
#
# options may be:
# profile: --profile=<profile> -> put a .yml file to ~/.oauthconfig
# connection data: --host=<host> --consumer_key=<consumer_key> --consumer_secret=<consumer_secret> --token=<token> --token_secret=<token_secret>

# HINT:
# - use with repl gem for nice handling, see http://github.com/defunkt/repl
# - make sure to have rlwrap installed, too: http://utopia.knoware.nl/~hlub/rlwrap/

# Example calls
# post /feedbacks '<feedback><link href="http://api.qype.com/v1/reviews/66"  rel="http://schemas.qype.com/review"/><comment><![CDATA[This review contains offending text]]></comment></feedback>'
# post /places/31/checkins '<checkins><point>53.5505,9.93631</point></checkins>'
# get /positions/53.55224,9.999/recommended_places
# get /locators/de600-hamburg/feed
# get /badges
# get /users/tobiasb/badges
# get /places/31.json?expand=popular_checkins

# TODO: 
# - save given keys to config

CFG_FILE = File.expand_path( '~/.oauthconfig' ) 

def main( params, opt = {})
  #parse CLI input
  method, uri, body = params.delete_if do |kv|
    next opt[$1.to_sym] = $2 if kv =~ /-?-([^=]+)=(.+)$/
    false
  end
  body = ask ">> request body:" if body.to_s.empty? && (method == "post" || method == "put")
  opt[:profile] ||= opt[:p] #shortcut for profile
  
  #load external config if profile given
  if opt[:profile] && File.exists?(CFG_FILE)
    cfg_options =  YAML.load_file( CFG_FILE )
    opt = symbolize_keys( cfg_options[opt[:profile]] ) if cfg_options[opt[:profile]]
  end
  
  return say " <%= color('#  ERROR: please provide method and uri', RED) %>" if method.to_s.empty? || uri.to_s.empty?
  
  response = execute( method, uri, body, opt)
  
  header = response.header
  color = (response.code.to_i < 400) ? 'GREEN' : 'RED' 
  say " <%= color('# -------------------------------------------------------------------------', #{color}) %>"
  say " <%= color('# Status: #{header.code} #{header.message}  - calling #{opt[:host]}#{uri}', BOLD, #{color}) %>"
  say " <%= color('# -------------------------------------------------------------------------', #{color}) %>"

  body = response.body
  body = " <%= color('# #{$1.gsub("'", "")} ', RED ) %>" if body =~ /<pre>(.+)<\/pre>/  
  body = JSON.pretty_generate( JSON.parse(body) ) if uri =~ /.json/  rescue ''
  say body
end

def execute( method, uri, body, options)
  if options[:consumer_key].empty?
    say "your consumer_key is empty, please get a key here: http://#{options[:host]}/api_consumers"
    say "call the script again with --consumer_key=<consumer_key> --consumer_secret=<consumer_secret>"
    exit
  end
  
  @consumer = OAuth::Consumer.new( options[:consumer_key], options[:consumer_secret], :site => "http://#{options[:host]}" )
  
  if options[:token]
    @access_token = OAuth::AccessToken.new(@consumer, options[:token], options[:token_secret])
  elsif !options[:read_only]
    @request_token = @consumer.get_request_token( {}, "oauth_callback" => "oob")
    say "To authorize, go to:\n  <%= color('http://#{options[:host].gsub('api.', 'www.')}/mobile/authorize?oauth_token=#{@request_token.token}', BOLD, UNDERLINE) %>\n\n" 
  
    verifier = ask ">> Verifier: "
    
    @access_token = @request_token.get_access_token( {}, "oauth_verifier" => verifier )
    
    say "add this to #{__FILE__} for skipping auth process next time:"
    say "options[:token]        = '#{@consumer.token}'"
    say "options[:token_secret] = '#{@consumer.secret}'"
  end
  
  url = "http://#{options[:host]}#{uri}"
  
  mime_type = (url =~ /\.json/) ? "application/json" : "application/xml"
  @consumer.request( method, url, @access_token, {}, body, { 'Accept' => mime_type, 'Content-Type' => mime_type } )
end
  
def symbolize_keys(hash)
  new_hash = {}
  hash.each { |key, value| new_hash[key.to_sym] = value }  
  new_hash
end

main( $* )