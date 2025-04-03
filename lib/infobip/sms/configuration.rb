# frozen_string_literal: true

module Infobip
  module Sms
    class Configuration
      attr_accessor :identifier, :base_url, :api_key, :sms_identifier, :sms_endpoint, :sms_reports_endpoint
  
      def initialize
        @identifier           = nil
        @base_url             = nil
        @sms_identifier       = nil
        @api_key              = nil
        @sms_endpoint         = nil
        @sms_reports_endpoint = nil
      end
    end
  end
end
