CommonRegexRuby
=============

[![Gem Version](https://badge.fury.io/rb/commonregex.svg)](http://badge.fury.io/rb/commonregex) 
[![Build Status](https://travis-ci.org/talyssonoc/CommonRegexRuby.svg?branch=master)](https://travis-ci.org/talyssonoc/CommonRegexRuby)

[CommonRegex](https://github.com/madisonmay/CommonRegex/ "CommonRegex") port for Ruby

Find a lot of kinds of common information in a string.

Pull requests welcome!

Please note that this is currently English/US specific.

Installation
============

To install CommonRegexRuby, just run:

```sh
    $ gem install commonregex
```

Now you're able to use the `CommonRegex` class, check the API and the examples.

API
===

Instance methods will return the results relative to the text passed at the constructor.
Class methods will receive a text as parameter and return the results relative to it.

Possible instance and class methods:

* `get_dates([text])`
* `get_times([text])`
* `get_phones([text])`
* `get_links([text])`
* `get_emails([text])`
* `get_ipv4([text])`
* `get_ipv6([text])`
* `get_hex_colors([text])`
* `get_acronyms([text])`
* `get_money([text])`
* `get_percentages([text])` (matches percentages between 0.00% and 100.00%)
* `get_credit_cards([text])`
* `get_addresses([text])`

Examples
========

```ruby
    text = "John, please get that article on www.linkedin.com to me by 5:00PM\n"
    "on Jan 9th 2012. 4:00 would be ideal, actually. If you have any questions,\n"
    "you can reach my associate at (012)-345-6789 or associative@mail.com.\n"
    "I\'ll be on UK during the whole week on a J.R.R. Tolkien convention."
    
    common_regex = CommonRegex.new(text)
    put common_regex.get_dates
    // ["Jan 9th 2012"]
    puts common_regex.get_times
    // ["5:00PM", "4:00"]
    puts common_regex.get_phones
    // ["(012)-345-6789"]
    puts common_regex.get_links
    // ["www.linkedin.com"]
    puts common_regex.get_emails
    // ["associative@mail.com"]
    puts common_regex.get_acronyms
    // ["UK", "J.R.R."]

```

Alternatively, you can use class methods.

```ruby

    puts CommonRegex.get_times 'When are you free? Do you want to meet up for coffee at 4:00?'
    // ["4:00"]
    puts CommonRegex.get_money 'They said the price was US$5,000.90, actually it is US$3,900.5. It\'s $1100.4 less, can you imagine this?'
    // ["US$5,000.90", "US$3,900.5", "$1100.4"]
    puts CommonRegex.get_percentages 'I\'m 99.9999999% sure that I\'ll get a raise of 5%.'
    // ["99.9999999%", "5%"]
    puts CommonRegex.get_ipv6 'The IPv6 address for localhost is 0:0:0:0:0:0:0:1, or alternatively, ::1.'
    // ["0:0:0:0:0:0:0:1", "::1"]

```

CommonRegex Ports
=================
There are CommonRegex ports for other languages, see [here](https://github.com/madisonmay/CommonRegex/#commonregex-ports "CommonRegex ports")
