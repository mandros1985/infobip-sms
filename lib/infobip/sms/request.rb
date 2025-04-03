# frozen_string_literal: true

module Infobip
  module Sms
    class Request
      attr_accessor :response, :request
  
      class << self
        attr_accessor :configuration
      end
  
      def self.configure
        self.configuration ||= ::Infobip::Sms::Configuration.new
        yield(configuration)
      end
  
      def initialize(base_url: nil, method: nil, payload: nil,
                     open_timeout: nil, read_timeout: nil, keep_alive_timeout: nil,
                     verify_mode: nil, body: nil, query: nil)
        raise "No configuration credentials provided !" if ::Infobip::Sms::Request.configuration.blank?
  
        @base_url                = base_url || ::Infobip::Sms::Request.configuration.base_url
        @method             = method.present? ? method.to_s.downcase.intern : :get
        @payload            = payload
        @body               = body
        @query              = query
        @open_timeout       = open_timeout || 2.minutes
        @read_timeout       = read_timeout || 2.minutes
        @keep_alive_timeout = keep_alive_timeout || 20.seconds
        @verify_mode        = verify_mode || OpenSSL::SSL::VERIFY_NONE
      end
  
      def make_request(path:)
        retry_count ||= 0
        @path = "/#{path}" if path[0] != "/" && path.size >= 1
  
        uri_obj = uri(host: base_url, path: path)
  
        resp = Net::HTTP.start(uri_obj.host, uri_obj.port, use_ssl: uri_obj.scheme == "https",
                                                           open_timeout: open_timeout, read_timeout: read_timeout,
                                                           keep_alive_timeout: keep_alive_timeout, verify_mode: verify_mode) do |http|
          @request = build_request_method(uri: uri_obj)
          http.request(request)
        end
        case resp
        when Net::HTTPSuccess
          parse(body: resp.body)
        else
          resp.value
        end
      rescue Net::HTTPServerException => e
        raise(e) unless (retry_count += 1) <= 3
  
        retry
      end
  
      def build_request_method(uri:)
        r = case method
            when :get
              Net::HTTP::Get.new uri
            when :post
              Net::HTTP::Post.new uri
            when :patch
              Net::HTTP::Patch.new uri
            when :put
              Net::HTTP::Put.new uri
            else
              raise "Unexpected method: #{method}"
            end
        r["OpenStack-Identity"] = ::Infobip::Sms::Request.configuration.identifier
        r["Authorization"] = "App #{::Infobip::Sms::Request.configuration.api_key}"
        if body.present?
          r["Content-Type"] = "application/json"
          r.body = body.try(:to_json)
        end
        r.set_form_data(payload) if payload.present?
        # r.basic_auth user, password
        r
      end
  
      def parse(body:)
        body = JSON.parse(body)
        symbolize(body)
      rescue JSON::ParserError
        body
      end
  
      def symbolize(body)
        if body.is_a?(Array)
          body.map do |array|
            symbolize(array)
          end
        else
          body.deep_transform_keys(&:underscore).deep_symbolize_keys
        end
      end
  
      def uri(host:, path:)
        uri = URI.parse(host + path)
        uri.query = URI.encode_www_form(query) if query.present?
        uri
      end
  
      private
  
      attr_reader :base_url, :method, :payload, :open_timeout,
                  :read_timeout, :keep_alive_timeout, :verify_mode,
                  :path, :body, :query
    end
  end
end
