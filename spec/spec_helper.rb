# frozen_string_literal: true

require "infobip/sms"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"
  
  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!
  
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  
  config.before do
    ::Infobip::Sms::Request.configure do |c|
      c.identifier           = 'app_id'
      c.base_url             = 'http://example.com'
      c.api_key              = '123-123'
      c.sms_identifier       = 'Test'
      c.sms_endpoint         = '/send_endpoint'
      c.sms_reports_endpoint = '/reports_endpoint'
    end
    
    http = double
    allow(Net::HTTP).to receive(:start).and_yield http
    allow(http).to \
      receive(:request).with(an_instance_of(Net::HTTP::Get))
                       .and_return(Net::HTTPOK.new("1.0", "200", "success"))
    allow(http).to \
      receive(:request).with(an_instance_of(Net::HTTP::Post))
                       .and_return(Net::HTTPOK.new("1.0", "200", "success"))
  end
end
