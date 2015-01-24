gem 'minitest'

require 'minitest/autorun'

$:.unshift File.expand_path("../lib", File.dirname(__FILE__))
require 'commonregex'

class TestCommonRegex < Minitest::Test
  def setup
    @text = "John, please get that article on www.linkedin.com to me by 5:00PM\n"\
      "on Jan 9th 2012. 4:00 would be ideal, actually. If you have any questions,\n"\
      "you can reach my associate at (012)-345-6789 or associative@mail.com.\n"\
      "I\'ll be on UK during the whole week on a J.R.R. Tolkien convention, starting friday at 4PM."

    @common_regex = CommonRegex.new(@text)
  end

  def test_dates
    assert_equal @common_regex.get_dates, ['Jan 9th 2012']
  end

  def test_times
    assert_equal @common_regex.get_times, ['5:00PM', '4:00', '4PM']
  end

  def test_phones
    assert_equal @common_regex.get_phones, ['(012)-345-6789']
  end

  def test_links
    assert_equal @common_regex.get_links, ['www.linkedin.com']
  end

  def test_emails
    assert_equal @common_regex.get_emails, ['associative@mail.com']
  end

  def test_ipv4
    assert_equal CommonRegex.get_ipv4('The IPv4 address for localhost is 127.0.0.1'), ['127.0.0.1']
  end

  def test_ipv6
    assert_equal CommonRegex.get_ipv6('The IPv6 address for localhost is 0:0:0:0:0:0:0:1, or alternatively ::1, but not :1:.'), ['0:0:0:0:0:0:0:1', '::1']
  end

  def test_hex_colors
    assert_equal CommonRegex.get_hex_colors('Did you knew that Hacker News orange is #ff6600?'), ['#ff6600']
  end

  def test_acronyms
    assert_equal @common_regex.get_acronyms, ['UK', 'J.R.R.']
  end

  def test_money
    assert_equal CommonRegex.get_money('They said the price was US$5,000.90, actually it is US$3,900.5. It\'s $1100.4 less, can you imagine this?'),
                                        ['US$5,000.90', 'US$3,900.5', '$1100.4']
  end

  def test_percentages
    assert_equal CommonRegex.get_percentages('I\'m 99.9999999% sure that I\'ll get a raise of 5%.'), ['99.9999999%', '5%']
  end

  def test_credit_cards
    assert_equal CommonRegex.get_credit_cards('His credit card number can be writen as 1234567891011121 or 1234-5678-9101-1121, but not 123-4567891011121.'),
                                                ['1234567891011121', '1234-5678-9101-1121']
  end

  def test_addresses
    text = 'checkout the new place at 101 main st., 504 parkwood drive, 3 elm boulevard, 500 elm street, 101 main straight';

    matches = [
    '101 main st.',
    '504 parkwood drive',
    '3 elm boulevard',
    '500 elm street'
    ];

    assert_equal CommonRegex.get_addresses(text), matches
  end

end
