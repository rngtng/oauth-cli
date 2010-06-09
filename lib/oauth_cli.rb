require 'highline/import'
require 'oauth'
require 'json'
require 'yaml'

begin
  require 'ap' #try to load awesome_print for nice json output
rescue LoadError
end

HighLine.track_eof = false #hotfix to make highline work

class OauthCli

  attr_reader :options
  
  def initialize(profile = nil)
    @options = {}
    connect(profile)
  end
  
  def connect(profile)
    return false if !profile.is_a?(Hash) && !OauthCli.profiles[profile]
    @options = OauthCli.profiles[profile] || profile
    
    #add http if missing
    [:host, :reg_url, :auth_url].each do |key|
      @options[key] = "http://#{@options[key]}" unless @options[key] =~ /^http/
    end
    
    @consumer     = OAuth::Consumer.new(@options[:consumer_key], @options[:consumer_secret], :site => @options[:host])
    @access_token = OAuth::AccessToken.new(@consumer, @options[:token], @options[:token_secret]) if @options[:token]

    connected?
  end

  def connected?
    # TODO check if host available?
    @options[:consumer_key] && @options[:consumer_secret] && @options[:host]
  end
  
  def auth?
    @access_token
  end

  def access_request_url
    @request_token = @consumer.get_request_token({}, "oauth_callback" => "oob")
    @options[:auth_url] ||= "#{@options[:host].gsub('api.', 'www.').gsub('v1/', '')}/mobile/authorize" #That's for Qype only!!
    url = "#{@options[:auth_url]}?oauth_token=#{@request_token.token}"
  end
  
  def access_token(verifier)
    request_url unless @request_token
    @access_token = @request_token.get_access_token({}, "oauth_verifier" => verifier)
  end
  
  def request(method, uri, body = nil)
    unless %w(get post put delete).include? method.to_s
      say_message "Wrong HTTP Method: #{method}  - calling #{@options[:host]}#{uri}", 'RED'
      return
    end

    uri  = ask_prompt "request uri" if !uri
    body = ask_prompt "request body" if !body && (method == "post" || method == "put")
    
    url = @options[:host] + uri

    @options[:mime_type]    ||= (url =~ /\.json/) ? "application/json" : "application/xml"
    @options[:content_type] ||= (url =~ /\.json/) ? "application/json" : "application/xml"

    response = @consumer.request(method, url, @access_token, {}, body, { 'Accept' => @options[:mime_type], 'Content-Type' => @options[:content_type] })

    header = response.header

    color = (response.code.to_i < 400) ? 'GREEN' : 'RED'
    say_message "Status: #{header.code} #{header.message}  - calling #{@options[:host]}#{uri}", color

    body = response.body
    if header.content_type =~ /json/
      body = JSON.parse(body)
      ap(body) rescue say(JSON.pretty_generate(body))
      return
    end

    body = " <%= color('# #{$1.gsub("'", "")} ', RED) %>" if body =~ /<pre>(.+)<\/pre>/
    say body
  end

  ####### Static Setup Mehtods
  
  def self.inialize
    @profiles || {}
  end
  
  def self.load_profiles(cfg_file, tmp_file)
    @cfg_file = cfg_file #keep so we can save back to file
    @profiles = load(cfg_file)
    @templates = load(tmp_file)
  end
  
  def self.save_profiles
    return unless @cfg_file
    File.open(@cfg_file, 'w') do |out|
       YAML.dump(@profiles, out)
    end
  end

  def self.add_profile(name, values)
    @profiles[name] = values
    name
  end
    
  def self.profiles
    @profiles || {}
  end

  def self.templates
    @templates || {}
  end

  def self.parse_args(args, opt = {}, last_arg = nil)
    @profiles ||= {}
    method, uri, body  = args.clone.delete_if do |kv|
      next opt[$1.to_sym] = $2  if kv =~ /-?-([^=]+)=(.+)$/   #catches --param=value
      next opt[last_arg] = kv   if last_arg && !opt[last_arg] #catches value
      next last_arg = $1.to_sym if kv =~ /^-?-(.+)$/          #catches --param
      false
    end
    
    profile = opt.delete(:profile) || opt.delete(:p)

    if !@profiles[profile] && opt.any?
      profile ||= 'commandline'
      @profiles[profile] = opt
      save_profiles unless profile == 'commandline'
    end        
      
    if !@profiles[profile] && @default_profile
      profile = @default_profile
      say "Using default profile: #{profile}"
    end
    
    if profile && !@profiles[profile]
      say_error "Profile #{profile} not found"
      profile = nil
    end
    
    [method, uri, body, profile]
  end
  
  private
  def self.load(file)
    hash = YAML.load_file(file) if File.exists?(file)
    return {} unless hash.is_a?(Hash)
    
    #symbolises keys and finde default profile
    hash.each do |profile, options|
      options.keys.each do |key| 
        hash[profile][key.to_sym] = hash[profile].delete(key)
        @default_profile = profile if key.to_sym == :default
      end
    end
    hash
  end
  
end


def say_message(message, color = 'WHITE')
  say "<%= color('# -------------------------------------------------------------------------', #{color}) %>"
  say "<%= color('# #{message}', BOLD, #{color} ) %>"
  say "<%= color('# -------------------------------------------------------------------------', #{color}) %>"
end

def say_error(error)
  say_message "ERROR: #{error}", 'RED'
end

def ask_prompt(question)
  ask " |-- #{question} >> "  
end
