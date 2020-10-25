# -*- encoding: utf-8 -*-
# stub: solidus_paypal_commerce_platform 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "solidus_paypal_commerce_platform".freeze
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "changelog_uri" => "https://github.com/solidusio-contrib/solidus_paypal_commerce_platform/releases", "homepage_uri" => "https://github.com/solidusio-contrib/solidus_paypal_commerce_platform", "source_code_uri" => "https://github.com/solidusio-contrib/solidus_paypal_commerce_platform" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Sean Denny".freeze, "Elia Schito".freeze]
  s.bindir = "exe".freeze
  s.date = "2020-10-13"
  s.email = "contact@solidus.io".freeze
  s.homepage = "https://github.com/solidusio-contrib/solidus_paypal_commerce_platform".freeze
  s.licenses = ["BSD-3-Clause".freeze]
  s.required_ruby_version = Gem::Requirement.new("~> 2.5".freeze)
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Integrate Solidus with Paypal Commerce Platform".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<deface>.freeze, ["~> 1.5"])
      s.add_runtime_dependency(%q<solidus_core>.freeze, [">= 2.0.0", "< 3"])
      s.add_runtime_dependency(%q<solidus_support>.freeze, ["~> 0.5"])
      s.add_runtime_dependency(%q<solidus_webhooks>.freeze, ["~> 0.2.0"])
      s.add_runtime_dependency(%q<paypal-checkout-sdk>.freeze, [">= 0"])
      s.add_development_dependency(%q<cuprite>.freeze, [">= 0"])
      s.add_development_dependency(%q<solidus_dev_support>.freeze, ["~> 2.1"])
    else
      s.add_dependency(%q<deface>.freeze, ["~> 1.5"])
      s.add_dependency(%q<solidus_core>.freeze, [">= 2.0.0", "< 3"])
      s.add_dependency(%q<solidus_support>.freeze, ["~> 0.5"])
      s.add_dependency(%q<solidus_webhooks>.freeze, ["~> 0.2.0"])
      s.add_dependency(%q<paypal-checkout-sdk>.freeze, [">= 0"])
      s.add_dependency(%q<cuprite>.freeze, [">= 0"])
      s.add_dependency(%q<solidus_dev_support>.freeze, ["~> 2.1"])
    end
  else
    s.add_dependency(%q<deface>.freeze, ["~> 1.5"])
    s.add_dependency(%q<solidus_core>.freeze, [">= 2.0.0", "< 3"])
    s.add_dependency(%q<solidus_support>.freeze, ["~> 0.5"])
    s.add_dependency(%q<solidus_webhooks>.freeze, ["~> 0.2.0"])
    s.add_dependency(%q<paypal-checkout-sdk>.freeze, [">= 0"])
    s.add_dependency(%q<cuprite>.freeze, [">= 0"])
    s.add_dependency(%q<solidus_dev_support>.freeze, ["~> 2.1"])
  end
end
