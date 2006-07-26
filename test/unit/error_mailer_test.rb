require File.dirname(__FILE__) + '/../test_helper'
require 'error_mailer'

class ErrorMailerTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"
  
  include ActionMailer::Quoting
  fixtures :users

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    @sent_mail = ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
  end

  def test_should_send_snapshot
    @request = ActionController::TestRequest.new
    @session = @request.session[:user] = User.find(:first)
    begin
      raise NoMethodError
    rescue => exc
      assert_nothing_raised { 
        ErrorMailer.deliver_snapshot(exc, 
          exc.clean_backtrace, 
          @session.instance_variable_get("@data"), 
          { 'controller' => 'test', 'action' => 'testing' }, 
          'sample @request.env')
      }
      assert_equal 1, @sent_mail.size
      assert @sent_mail[0].encoded.match("/test/unit/error_mailer_test.rb")
      assert @sent_mail[0].encoded.match(":in `test_should_send_snapshot'</")
      assert_not_nil @sent_mail[0].encoded
    end    
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/error_mailer/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
