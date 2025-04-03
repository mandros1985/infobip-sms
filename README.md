# Infobip::Sms

Library to interact with INFOBIP SMS provider 

To experiment with the code, run `bin/console` for an interactive prompt.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
  $ bundle add infobip-sms
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
  $ gem install infobip-sms
```

## Usage
    
    When bundled, set up a initializer to provide URL and the Identifier

    Simply create a protool_api_client.rb file in the initializers directory, and set it up like this:

```ruby
  ::Infobip::Sms::Request.configure do |c|
    c.identifier           = 'Application name to identify in headers by'
    c.base_url             = 'Infobip api base url configured'
    c.api_key              = 'Infobip Api Key'
    c.sms_identifier       = 'Message sender name'
    c.sms_endpoint         = '/send_endpoint'
    c.sms_reports_endpoint = '/report_endpoint'
  end
```

Examples use for Infobip::Sms CLIENT

```ruby
  ::Infobip::Sms::Connection.new.send_single_sms(phone_number_with_prefix: +48600500400, content: "Some Message", custom_identifier: nil || "SMS_SENDER_NAME")
```

response:
```ruby
  {
    "messages": [
      {
        "to": "41793026727",
        "status": {
          "groupId": 1,
          "groupName": "PENDING",
          "id": 26,
          "name": "PENDING_ACCEPTED",
          "description": "Message sent to next instance"
        },
        "messageId": "33644496xxxx05285365"
      }
    ]
  }
```

```ruby
  Infobip::Sms::Connection.new.get_reports(query: {bulkId: '44368913xxxxx434966'})
```

response: 
```ruby
  {
    results: [
      { bulk_id: "443689xxxxxx35434966",
        message_id: "44368913715xx4967",
        to: "4860xxx",
        from: "TEST",
        sent_at: "2025-04-03T14:05:37.157+0000",
        done_at: "2025-04-03T14:05:37.615+0000",
        sms_count: 1,
        mcc_mnc: "null",
        price: { price_per_message: 0.0558194, currency: "PLN" },
        status: { group_id: 3, group_name: "DELIVERED", id: 5, name: "DELIVERED_TO_HANDSET", description: "Message delivered to handset" },
        error: { group_id: 0, group_name: "OK", id: 0, name: "NO_ERROR", description: "No Error", permanent: false }
      },
      {
        bulk_id: "443689xxxxxx434966",
        message_id: "443689xx35434968",
        to: "4866xxx",
        from: "TEST",
        sent_at: "2025-04-03T14:05:37.157+0000",
        done_at: "2025-04-03T14:05:38.793+0000",
        sms_count: 1,
        mcc_mnc: "null",
        price: { price_per_message: 0.0558194, currency: "PLN" },
        status: { group_id: 3, group_name: "DELIVERED", id: 5, name: "DELIVERED_TO_HANDSET", description: "Message delivered to handset" },
        error: { group_id: 0, group_name: "OK", id: 0, name: "NO_ERROR", description: "No Error", permanent: false }
      }
    ]
}
```

```ruby
  ::Infobip::Sms::Connection.new.send_bulk_sms(query: { bulkId: '123', messageId: '123' })
```

response: 
```ruby 
{
    "results": [
        {
            "bulkId": "33649386xxx572262",
            "messageId": "336xx86024303572263",
            "to": "41793026727",
            "from": "InfoSMS",
            "sentAt": "2021-11-09T21:37:40.258+0000",
            "doneAt": "2021-11-09T21:37:42.910+0000",
            "smsCount": 1,
            "mccMnc": "null",
            "price": {
                "pricePerMessage": 0,
                "currency": "EUR"
            },
            "status": {
                "groupId": 3,
                "groupName": "DELIVERED",
                "id": 5,
                "name": "DELIVERED_TO_HANDSET",
                "description": "Message delivered to handset"
            },
            "error": {
                "groupId": 0,
                "groupName": "OK",
                "id": 0,
                "name": "NO_ERROR",
                "description": "No Error",
                "permanent": false
            }
        }
    ]
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mandros1985/infobip-sms. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/mandros1985/infobip-sms/blob/name/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Infobip::Sms project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/infobip-sms/blob/name/CODE_OF_CONDUCT.md).
