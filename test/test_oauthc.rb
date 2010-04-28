require 'helper'

class TestOauthCli < Test::Unit::TestCase 
  
  def setup
    @oauthc = File.dirname(File.dirname(__FILE__)) + "/bin/oauthc"
  end
    
  def test_should_show_help
    output = `#{@oauthc} -h`
    assert output =~ /Usage: oauthc/
  end
  
  def _test_should_show_error_on_profile
    require 'highline/import'
    HighLine.any_instance.stubs(:choose).returns("")
    
    OauthCli.stubs(:parse_args).returns(['get', '/asd', '', 'unknown', {}])
    OauthCli.any_instance.stubs(:request).returns("")
    load "../bin/oauthc"
    assert output =~ /Profile unknown not found/
  end
  
end