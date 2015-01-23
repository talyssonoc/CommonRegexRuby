class CommonRegex

	# Methods used to generate @date_regex
	def self.opt (regex)
		'(?:' + regex + ')?'
	end

	def self.group(regex)
		'(?:' + regex + ')'
	end

	def self.any(regexes)
		regexes.join('|')
	end

	# Generate @date_regex
	month_regex = '(?:jan\\.?|january|feb\\.?|february|mar\\.?|march|apr\\.?|april|may|jun\\.?|june|jul\\.?|july|aug\\.?|august|sep\\.?|september|oct\\.?|october|nov\\.?|november|dec\\.?|december)'
	day_regex = '[0-3]?\\d(?:st|nd|rd|th)?'
	year_regex = '\\d{4}'

	@@date_regex = Regexp.new('(' + CommonRegex.group(
		CommonRegex.any(
			[
				day_regex + '\\s+(?:of\\s+)?' + month_regex,
				month_regex + '\\s+' + day_regex
			]
		)
	) + '(?:\\,)?\\s*' + CommonRegex.opt(year_regex) + '|[0-3]?\\d[-/][0-3]?\\d[-/]\\d{2,4})', Regexp::IGNORECASE || Regexp::MULTILINE)

	@@time_regex = /\b((0?[0-9]|1[0-2])(:[0-5][0-9])?(am|pm)|([01]?[0-9]|2[0-3]):[0-5][0-9])/im
	@@phone_regex = /(\d?[^\s\w]*(?:\(?\d{3}\)?\W*)?\d{3}\W*\d{4})/im
	@@links_regex = /((?:https?:\/\/|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}\/)(?:[^\s()<>]+|\((?:[^\s()<>]+|(?:\([^\s()<>]+\)))*\))+(?:\((?:[^\s()<>]+|(?:\([^\s()<>]+\)))*@\)|[^\s`!()\[\]{};:\'".,<>?]))/im
	@@emails_regex = /([a-z0-9!#$%&'*+\/=?\^_`{|}~\-]+@([a-z0-9]+\.)+([a-z0-9]+))/im
	@@ipv4_regex = /\b(((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))\b/m
	@@ipv6_regex = /((([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}:[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){5}:([0-9A-Fa-f]{1,4}:)?[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){4}:([0-9A-Fa-f]{1,4}:){0,2}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){3}:([0-9A-Fa-f]{1,4}:){0,3}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){2}:([0-9A-Fa-f]{1,4}:){0,4}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(([0-9A-Fa-f]{1,4}:){0,5}:((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(::([0-9A-Fa-f]{1,4}:){0,5}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|([0-9A-Fa-f]{1,4}::([0-9A-Fa-f]{1,4}:){0,5}[0-9A-Fa-f]{1,4})|(::([0-9A-Fa-f]@{1,4}:){0,6}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){1,7}:))\b/im
	@@hex_colors_regex = /(#(?:[0-9a-fA-F]{3}){1,2})\b/im
	@@acronyms_regex = /\b(([A-Z]\.)+|([A-Z]){2,})/m
	@@money_regex = /(((^|\b)US?)?\$\s?[0-9]{1,3}((,[0-9]{3})+|([0-9]{3})+)?(\.[0-9]{1,2})?\b)/m
	@@percentage_regex = /((100(\.0+)?|[0-9]{1,2}(\.[0-9]+)?)%)/m
	@@credit_card_regex = /((?:(?:\d{4}[- ]){3}\d{4}|\d{16}))(?![\d])/m
	@@address_regex = /(\d{1,4} [\w\s]{1,20}(?:(street|avenue|road|highway|square|traill|drive|court|parkway|boulevard)\b|(st|ave|rd|hwy|sq|trl|dr|ct|pkwy|blvd)\.(?=\b)?))/im

	def initialize(text = '')
		@text = text;
	end

	def get_dates(text = @text)
		get_matches(text, @@date_regex)
	end

	def get_times(text = @text)
		get_matches(text, @@time_regex)
	end

	def get_phones(text = @text)
		get_matches(text, @@phone_regex)
	end

	def get_links(text = @text)
		get_matches(text, @@links_regex)
	end

	def get_emails(text = @text)
		get_matches(text, @@emails_regex)
	end

	def get_ipv4(text = @text)
		get_matches(text, @@ipv4_regex)
	end

	def get_ipv6(text = @text)
		get_matches(text, @@ipv6_regex)
	end

	def get_hex_colors(text = @text)
		get_matches(text, @@hex_colors_regex)
	end

	def get_acronyms(text = @text)
		get_matches(text, @@acronyms_regex)
	end

	def get_money(text = @text)
		get_matches(text, @@money_regex)
	end

	def get_percentages(text = @text)
		get_matches(text, @@percentage_regex)
	end

	def get_credit_cards(text = @text)
		get_matches(text, @@credit_card_regex)
	end

	def get_addresses(text = @text)
		get_matches(text, @@address_regex)
	end

private
	
	def get_matches(text, regex)
		text.scan(regex).collect{|x| x[0]}
	end

end