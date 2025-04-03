# frozen_string_literal: true

module Infobip
  module Sms
    class Connection
      def call(path:, method: :post, body: nil, query: nil)
        ::Infobip::Sms::Request.new(method: method, body: body, query: query).make_request(path: path)
      end
  
      # Send sms message - single sms
      # @param phone_number_with_prefix [String]
      # @param content [String]
      # @param custom_identifier [String]
      def send_single_sms(phone_number_with_prefix:, content:, custom_identifier: nil)
        body = {
          "messages": [
            {
              "from": custom_identifier || ::Infobip::Sms::Request.configuration.sms_identifier,
              "destinations": [
                {
                  "to": phone_number_with_prefix
                }
              ],
              "text": content
            }
          ]
        }
        call(path: ::Infobip::Sms::Request.configuration.sms_endpoint || "/sms/2/text/advanced", method: :post, body: body)
      end
      
      # Send sms message - bulk sms
      # @param phone_numbers_with_prefix [Array]
      # @param content [String]
      # @param custom_identifier [String]
      def send_bulk_sms(phone_numbers_with_prefix:, content:, custom_identifier: nil)
        body = { "messages": [] }
        phone_numbers_with_prefix.each do |phone_number|
          body[:"messages"] << {
            "from": custom_identifier || ::Infobip::Sms::Request.configuration.sms_identifier,
            "destinations": [
              {
                "to": phone_number
              }
            ],
            "text": content
          }
        end
        
        call(path: ::Infobip::Sms::Request.configuration.sms_endpoint || "/sms/2/text/advanced", method: :post, body: body)
      end
      
      # Check report for bulk or for message_id
      # @param query [Ruby Hash]
      # {bulkId: '123', messageId: '123'}
      # /sms/1/reports?bulkId={{recentBulkId}}&messageId={{recentMessageId}}&limit=453367
      # LOGS CAN ONLY BE QUERIED ONCE ! after that results are empty
      def get_reports(query:)
        call(path: ::Infobip::Sms::Request.configuration.sms_reports_endpoint || "/sms/1/reports", method: :get, query: query)
      end
    end
  end
end
