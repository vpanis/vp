SolidusWebhooks
===============

Provides comprehensive Webhook support for Solidus, with a simple and powerful way to register them and route payloads to appropriate actions, either synchronous or delayed.

Usage
-----

A Webhook receiver is just a callable and can be registered in the Solidus configuration as follows:

```ruby
SolidusWebhooks.config.register_webhook_handler :tracking_number, -> payload {
  order = Spree::Order.find_by!(number: payload[:order])
  shipment = order.shipments.find_by!(number: payload[:shipment])
  shipment.update!(tracking: payload[:tracking])
}
```

This will enable sending `POST` requests to `/webhooks/tracking-number` with a JSON payload like this:

```json
{
  "order": "R1234567890",
  "shipment": "S1234567890",
  "tracking": "T123-456-789"
}
```

### Handlers requirements

The only requirement on handlers is for them to respond to `#call` and accept a payload.

Example:

```ruby
class TrackingNumberHandler
  def call(payload)
    order = Spree::Order.find_by!(number: payload[:order])
    shipment = order.shipments.find_by!(number: payload[:shipment])
    shipment.update!(tracking: payload[:tracking])
  end
end

SolidusWebhooks.config.register_webhook_handler :tracking_number, TrackingNumberHandler
```


### Making the handler asynchronous

To make a handler asynchronous just make its implementation internally call your preferred job handler (e.g. ActiveJob). In most cases you'll want to filter, prepare, and validate the payload for the job of your choice, to avoid ingesting and invalid input.

Example:

```ruby
SolidusWebhooks.config.register_webhook_handler :tracking_number, -> payload {
  UpdateTrackingNumberJob.perform_later(
    order: payload.fetch(:order)
    shipment: payload.fetch(:shipment)
    tracking: payload.fetch(:tracking)
  )
}
```


### Payload routing

If your handler can receive different kind of payloads the most common technique is to route them to appropriate sub-handlers (that can be an ActiveJob class or a service class).

```ruby
SolidusWebhooks.config.register_webhook_handler :tracking_number, -> payload {
  case payload[:tracking]
  when /^FOO(\d+-)+/
    UpdateFooTrackingNumberJob.perform_later(
      order: payload.fetch(:order)
      shipment: payload.fetch(:shipment)
      tracking: payload.fetch(:tracking)
    )
  when /^BAR(\d+-)+/
    UpdateBarTrackingNumberJob.perform_later(
      order: payload.fetch(:order)
      shipment: payload.fetch(:shipment)
      tracking: payload.fetch(:tracking)
    )
  else raise "unknown tracking service"
  end
}
```

### Restricting Permissions

It's good practice not to use admin-user tokens for webhooks, instead you should define a permission set tied to the webhook handler you're providing. Use the standard Solidus permission-sets to do that.

Example:

```ruby
module ReceiveTrackingWebhookPermission < Spree::PermissionSets::Base
  def activate!
    can :receive, Spree::Webhook do |webhook|
      webhook.id == :tracking_number
    end
  end
end

Spree::RoleConfiguration.configure do |config|
  config.assign_permissions :foo_tracking_service, %w[
    ReceiveTrackingWebhookPermission
  ]
end
```

### Accessing the API User

If you need to access the API user that is making the call to the webhook, you can just accept an additional argument in the callable handler.

Example:

```ruby
SolidusWebhooks.config.register_webhook_handler :tracking_number, -> payload, user {
  Rails.logger.info "Received payload from user #{user.email}: #{payload.to_json}"
  # …
}
```


Installation
------------

Add solidus_webhooks to your Gemfile:

```ruby
gem 'solidus_webhooks'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g solidus_webhooks:install
```

Testing
-------

First bundle your dependencies, then run `bin/rake`. `bin/rake` will default to building the dummy app if it does not exist, then it will run specs. The dummy app can be regenerated by using `bin/rake extension:test_app`.

```shell
bundle
bin/rake
```

To run [Rubocop](https://github.com/bbatsov/rubocop) static code analysis run

```shell
bundle exec rubocop
```

When testing your application's integration with this extension you may use its factories.
Simply add this require statement to your spec_helper:

```ruby
require 'solidus_webhooks/factories'
```

Sandbox app
-----------

To run this extension in a sandboxed Solidus application you can run `bin/sandbox`
The path for the sandbox app is `./sandbox` and `bin/rails` will forward any Rails command
to `sandbox/bin/rails`.

Example:

```shell
$ bin/rails server
=> Booting Puma
=> Rails 6.0.2.1 application starting in development
* Listening on tcp://127.0.0.1:3000
Use Ctrl-C to stop
```

Releasing
---------

Your new extension version can be released using `gem-release` like this:

```shell
bundle exec gem bump -v VERSION --tag --push --remote upstream && gem release
```

Copyright (c) 2020 Nebulab srls, released under the New BSD License
