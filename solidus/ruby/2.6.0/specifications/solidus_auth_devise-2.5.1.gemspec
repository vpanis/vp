# -*- encoding: utf-8 -*-
# stub: solidus_auth_devise 2.5.1 ruby lib

Gem::Specification.new do |s|
  s.name = "solidus_auth_devise".freeze
  s.version = "2.5.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "homepage_uri" => "https://github.com/solidusio/solidus_auth_devise", "source_code_uri" => "https://github.com/solidusio/solidus_auth_devise" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Solidus Team".freeze]
  s.bindir = "exe".freeze
  s.date = "2020-10-23"
  s.email = "contact@solidus.io".freeze
  s.homepage = "https://github.com/solidusio/solidus_auth_devise".freeze
  s.licenses = ["BSD-3-Clause".freeze]
  s.post_install_message = "NOTE: Rails 6 has removed secret_token in favor of secret_key_base, which was deprecated in\n Rails 5.2. solidus_auth_devise will keep using secret_token, when present, as the pepper. If\n secret_token is undefined or not available, secret_key_base will be used instead.".freeze
  s.required_ruby_version = Gem::Requirement.new("~> 2.4".freeze)
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Provides authentication and authorization services for use with Solidus by using Devise and CanCan.".freeze

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<deface>.freeze, ["~> 1.0"])
      s.add_runtime_dependency(%q<devise>.freeze, ["~> 4.1"])
      s.add_runtime_dependency(%q<devise-encryptable>.freeze, ["= 0.2.0"])
      s.add_runtime_dependency(%q<paranoia>.freeze, ["~> 2.4"])
      s.add_runtime_dependency(%q<solidus_core>.freeze, [">= 2.6", "< 3"])
      s.add_runtime_dependency(%q<solidus_support>.freeze, ["~> 0.5"])
      s.add_development_dependency(%q<solidus_backend>.freeze, [">= 2.6", "< 3"])
      s.add_development_dependency(%q<solidus_dev_support>.freeze, [">= 0.3.0"])
      s.add_development_dependency(%q<solidus_frontend>.freeze, [">= 2.6", "< 3"])
    else
      s.add_dependency(%q<deface>.freeze, ["~> 1.0"])
      s.add_dependency(%q<devise>.freeze, ["~> 4.1"])
      s.add_dependency(%q<devise-encryptable>.freeze, ["= 0.2.0"])
      s.add_dependency(%q<paranoia>.freeze, ["~> 2.4"])
      s.add_dependency(%q<solidus_core>.freeze, [">= 2.6", "< 3"])
      s.add_dependency(%q<solidus_support>.freeze, ["~> 0.5"])
      s.add_dependency(%q<solidus_backend>.freeze, [">= 2.6", "< 3"])
      s.add_dependency(%q<solidus_dev_support>.freeze, [">= 0.3.0"])
      s.add_dependency(%q<solidus_frontend>.freeze, [">= 2.6", "< 3"])
    end
  else
    s.add_dependency(%q<deface>.freeze, ["~> 1.0"])
    s.add_dependency(%q<devise>.freeze, ["~> 4.1"])
    s.add_dependency(%q<devise-encryptable>.freeze, ["= 0.2.0"])
    s.add_dependency(%q<paranoia>.freeze, ["~> 2.4"])
    s.add_dependency(%q<solidus_core>.freeze, [">= 2.6", "< 3"])
    s.add_dependency(%q<solidus_support>.freeze, ["~> 0.5"])
    s.add_dependency(%q<solidus_backend>.freeze, [">= 2.6", "< 3"])
    s.add_dependency(%q<solidus_dev_support>.freeze, [">= 0.3.0"])
    s.add_dependency(%q<solidus_frontend>.freeze, [">= 2.6", "< 3"])
  end
end
