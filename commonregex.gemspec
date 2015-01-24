# -*- encoding: utf-8 -*-

$:.unshift File.expand_path("../lib", __FILE__)

require "commonregex/version"

Gem::Specification.new do |s|
  s.name        = 'commonregex'
  s.version     = CommonRegex::VERSION
  s.license     = 'MIT'
  s.summary     = "CommonRegex port for Ruby"
  s.description = "Find a lot of kinds of common information in a string. CommonRegex port for Ruby."
  s.authors     = ["Talysson Oliveira Cassiano"]
  s.email       = 'talyssonoc@gmail.com'
  s.files       = ["lib/commonregex.rb", "lib/commonregex/version.rb"]
  s.homepage    = 'https://github.com/talyssonoc/CommonRegexRuby'
end
