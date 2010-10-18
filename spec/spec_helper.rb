begin
  # Require the preresolved locked set of gems.
  require File.expand_path('../../.bundle/environment', __FILE__)
rescue LoadError
  # Fallback on doing the resolve at runtime.
  require 'rubygems'
  require 'bundler'
  Bundler.setup
end

Bundler.require(:test, :default)

require 'encoding-dot-com'

class EncodingXpathMatcher
  def initialize(xpath)
    @xpath = xpath
  end

  def ==(post_vars)
    ! Nokogiri::XML(post_vars[:xml]).xpath(@xpath).empty?
  end
end

module XpathMatchers
  class HaveXpath
    def initialize(xpath)
      @xpath = xpath
    end

    def matches?(xml)
      @xml = xml
      Nokogiri::XML(xml).xpath(@xpath).any?
    end

    def failure_message
      "expected #{@xml} to have xpath #{@xpath}"
    end

    def negative_failure_message
      "expected #{@xml} not to have xpath #{@xpath}"
    end
  end

  def have_xpath(xpath)
    HaveXpath.new(xpath)
  end
end