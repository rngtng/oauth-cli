require 'helper'

class TestOauthCli < Test::Unit::TestCase 
  
  def test_should_init_oauth
    opt = {}
    @client = OauthCli.new(opt)
    assert @client
  end
  
  def test_should_parse_args_with_equal
    args = %w(--profile=test -host=http://host.com get /users?name=test my_body)
    assert_equal ['get', '/users?name=test', 'my_body', {:host => 'http://host.com'}, 'test'], OauthCli.parse_args(args)
  end
  
  def test_should_parse_args_without_equal_and_body
    args = %w(-p test --host http://host.com get /users?name=test)
    assert_equal ['get', '/users?name=test', nil, {:host => 'http://host.com'}, 'test'], OauthCli.parse_args(args)
  end
  
  def test_should_not_be_connected_on_empty_args
    assert !OauthCli.new.connected?
  end
  
  def test_should_add_http_to_host
    opt = { :host => "api.bbc.com", :auth_host => "http://test.domain", :reg_host => "https://test.domain", :consumer_key => "dummy_key"}
    @client = OauthCli.new(opt)
    
    assert_equal "http://api.bbc.com", @client.options[:host]
    assert_equal "http://test.domain", @client.options[:auth_host]
    assert_equal "https://test.domain", @client.options[:reg_host]
  end  
end