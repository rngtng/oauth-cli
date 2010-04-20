require 'helper'

class TestOauthCli < Test::Unit::TestCase 
  
  def test_should_init_oauth
    opt = {}
    @client = OauthCli.new(opt)
    assert @client
  end
  
  def test_should_add_http_to_host
    opt = { :host => "api.bbc.com", :auth_host => "http://test.domain", :reg_host => "https://test.domain", :consumer_key => "dummy_key"}
    @client = OauthCli.new(opt)
    
    assert_equal "http://api.bbc.com", @client.options[:host]
    assert_equal "http://test.domain", @client.options[:auth_host]
    assert_equal "https://test.domain", @client.options[:reg_host]
  end  
end