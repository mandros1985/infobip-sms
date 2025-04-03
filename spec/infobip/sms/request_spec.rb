# frozen_string_literal: true

require "spec_helper"

RSpec.describe ::Infobip::Sms::Request do
  it "has configured identifier" do
    expect(described_class.configuration.identifier).to eq "app_id"
  end
  
  it "has configured base_url" do
    expect(described_class.configuration.base_url).to eq "http://example.com"
  end
  
  it "has configured sms_identifier" do
    expect(described_class.configuration.sms_identifier).to eq "Test"
  end
  
  it "has configured api_key" do
    expect(described_class.configuration.api_key).to eq "123-123"
  end
  
  it "has configured sms_endpoint" do
    expect(described_class.configuration.sms_endpoint).to eq "/send_endpoint"
  end
  
  it "has configured sms_reports_endpoint" do
    expect(described_class.configuration.sms_reports_endpoint).to eq "/reports_endpoint"
  end
end
