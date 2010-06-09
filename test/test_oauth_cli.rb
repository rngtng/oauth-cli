require 'helper'

class TestOauthCli < Test::Unit::TestCase 
  
  def test_should_init_oauth
    assert OauthCli.new
  end
  
  def test_should_parse_args_with_equal
    args = %w(--profile=test -host=http://host.com get /users?name=test my_body)
    assert_equal ['get', '/users?name=test', 'my_body', 'test'], OauthCli.parse_args(args)
  end

  def test_should_parse_args_with_equal_no_profile
    args = %w(-host=http://host.com get /users?name=test my_body)
    assert_equal ['get', '/users?name=test', 'my_body', 'commandline'], OauthCli.parse_args(args)
  end
  
  def test_should_parse_args_without_equal_and_body
    args = %w(-p test --host http://host.com get /users?name=test)
    assert_equal ['get', '/users?name=test', nil, 'test'], OauthCli.parse_args(args)
  end
  
  def test_should_not_be_connected_on_empty_args
    assert !OauthCli.new.connected?
  end
  
  def test_should_be_connected
    assert OauthCli.new( :consumer_key => 'key', :consumer_secret => 'secret', :host => 'host' ).connected?
  end
    
  def test_should_add_http_to_url
    opt = { :host => "api.bbc.com", :auth_url => "http://test.domain", :reg_url => "https://test.domain", :consumer_key => "dummy_key"}
    @client = OauthCli.new(opt)
    
    assert_equal "http://api.bbc.com", @client.options[:host]
    assert_equal "http://test.domain", @client.options[:auth_url]
    assert_equal "https://test.domain", @client.options[:reg_url]
  end  
end