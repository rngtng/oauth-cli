require 'helper'

class TestOauthCli < Test::Unit::TestCase 
  
  def setup
    @oauthc = File.dirname(File.dirname(__FILE__)) + "/bin/oauthc"
  end
  
  def test_should_show_help
    output = `#{@oauthc}`
    assert output =~ /Usage: oauthc/
  end
  
  def test_should_show_error_on_profile
    output = `#{@oauthc} -p=unknown`
    assert output =~ /Profile unknown not found/
  end
  
end