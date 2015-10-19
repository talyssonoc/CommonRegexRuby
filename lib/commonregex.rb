require 'yaml'
require 'commonregex/version'

class CommonRegex
  METHODS = YAML.load_file(File.join(File.dirname(__FILE__),  'support', 'most_commom.yaml')) || {}

  def initialize(text = '')
    @text = text;
  end
  
  class << self
    # Methods used to generate @date_regex
    def opt(regex)
      '(?:' + regex + ')?'
    end

    def group(regex)
      '(?:' + regex + ')'
    end

    def any(regexes)
      regexes.join('|')
    end
  end

  # Generate @date_regex
  month_regex = '(?:jan\\.?|january|feb\\.?|february|mar\\.?|march|apr\\.?|april|may|jun\\.?|june|jul\\.?|july|aug\\.?|august|sep\\.?|september|oct\\.?|october|nov\\.?|november|dec\\.?|december)'
  day_regex = '[0-3]?\\d(?:st|nd|rd|th)?'
  year_regex = '\\d{4}'

  @@dates_regex = Regexp.new('(' + CommonRegex.group(
    CommonRegex.any(
      [
        day_regex + '\\s+(?:of\\s+)?' + month_regex,
        month_regex + '\\s+' + day_regex
      ]
    )
  ) + '(?:\\,)?\\s*' + CommonRegex.opt(year_regex) + '|[0-3]?\\d[-/][0-3]?\\d[-/]\\d{2,4})', Regexp::IGNORECASE || Regexp::MULTILINE)

  @@acronyms_regex = /\b(([A-Z]\.)+|([A-Z]){2,})/m
  @@addresses_regex = /(\d{1,4} [\w\s]{1,20}(?:(street|avenue|road|highway|square|traill|drive|court|parkway|boulevard)\b|(st|ave|rd|hwy|sq|trl|dr|ct|pkwy|blvd)\.(?=\b)?))/im
  @@credit_cards_regex = /((?:(?:\d{4}[- ]){3}\d{4}|\d{16}))(?![\d])/m
  @@emails_regex = /([a-z0-9!#$%&'*+\/=?\^_`{|}~\-]+@([a-z0-9]+\.)+([a-z0-9]+))/im
  @@hex_colors_regex = /(#(?:[0-9a-fA-F]{3}){1,2})\b/im
  @@ipv4_regex = /\b(((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))\b/m
  @@ipv6_regex = /((([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}:[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){5}:([0-9A-Fa-f]{1,4}:)?[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){4}:([0-9A-Fa-f]{1,4}:){0,2}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){3}:([0-9A-Fa-f]{1,4}:){0,3}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){2}:([0-9A-Fa-f]{1,4}:){0,4}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(([0-9A-Fa-f]{1,4}:){0,5}:((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(::([0-9A-Fa-f]{1,4}:){0,5}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|([0-9A-Fa-f]{1,4}::([0-9A-Fa-f]{1,4}:){0,5}[0-9A-Fa-f]{1,4})|(::([0-9A-Fa-f]@{1,4}:){0,6}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){1,7}:))\b/im
  @@links_regex = /((?:https?:\/\/|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}\/)(?:[^\s()<>]+|\((?:[^\s()<>]+|(?:\([^\s()<>]+\)))*\))+(?:\((?:[^\s()<>]+|(?:\([^\s()<>]+\)))*@\)|[^\s`!()\[\]{};:\'".,<>?]))/im
  @@money_regex = /(((^|\b)US?)?\$\s?[0-9]{1,3}((,[0-9]{3})+|([0-9]{3})+)?(\.[0-9]{1,2})?\b)/m
  @@percentages_regex = /((100(\.0+)?|[0-9]{1,2}(\.[0-9]+)?)%)/m
  @@phones_regex = /(\d?[^\s\w]*(?:\(?\d{3}\)?\W*)?\d{3}\W*\d{4})/im
  @@times_regex = /\b((0?[0-9]|1[0-2])(:[0-5][0-9])?(am|pm)|([01]?[0-9]|2[0-3]):[0-5][0-9])/im

  METHODS.each do |regex|
    class_eval <<-RUBY.gsub(/^\s{6}/, ''), __FILE__, __LINE__
      def self.get_#{regex}(text)
        get_matches(text, @@#{regex}_regex)
      end

      def get_#{regex}
        self.class.get_#{regex}(@text)
      end
    RUBY
  end

  private
    def self.get_matches(text, regex)
      text.scan(regex).collect{|x| x[0]}
    end
end
