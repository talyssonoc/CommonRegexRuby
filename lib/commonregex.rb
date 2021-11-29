require 'yaml'
require 'commonregex/version'

class CommonRegex
  METHODS = YAML.load_file(File.join(File.dirname(__FILE__),  'support', 'most_common.yml')) || {}

  def initialize(text = '')
    @text = text
  end
  
  class << self
    def opt(regex)
      "(?:#{regex})?"
    end

    def group(regex)
      "(?:#{regex})"
    end

    def any(regexes)
      regexes.join('|')
    end
  end

  # Generate @date_regex
  month_regex = '(?:jan\\.?|january|feb\\.?|february|mar\\.?|march|apr\\.?|april|may|jun\\.?|june|jul\\.?|july|aug\\.?|august|sep\\.?|september|oct\\.?|october|nov\\.?|november|dec\\.?|december)'
  day_regex = '[0-3]?\\d(?:st|nd|rd|th)?'
  year_regex = '\\d{4}'

  day_or_month = CommonRegex.any([
    day_regex + '\\s+(?:of\\s+)?' + month_regex,
    month_regex + '\\s+' + day_regex
  ])

  @@dates_regex = Regexp.new(
    ("(#{ CommonRegex.group(day_or_month) }" +  "(?:\\,)?\\s*#{ CommonRegex.opt(year_regex) }|[0-3]?\\d[-/][0-3]?\\d[-/]\\d{2,4})"),
    Regexp::IGNORECASE || Regexp::MULTILINE
  )

  @@acronyms_regex = /\b(([A-Z]\.)+|([A-Z]){2,})/m
  @@addresses_regex = /(\d{1,4} [\w\s]{1,20}(?:(street|avenue|road|highway|square|traill|drive|court|parkway|boulevard)\b|(st|ave|rd|hwy|sq|trl|dr|ct|pkwy|blvd)\.(?=\b)?))/im
  @@credit_cards_regex = /((?:(?:\d{4}[- ]){3}\d{4}|\d{16}))(?![\d])/m
  @@emails_regex = /([a-z0-9!#$%&'*+\/=?\^_`{|}~\-]+@([a-z0-9]+\.)+([a-z0-9]+))/im
  @@hex_colors_regex = /(#(?:[0-9a-fA-F]{3}){1,2})\b/im
  @@ipv4_regex = /\b(((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))\b/m
  @@ipv6_regex = /((([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}:[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){5}:([0-9A-Fa-f]{1,4}:)?[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){4}:([0-9A-Fa-f]{1,4}:){0,2}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){3}:([0-9A-Fa-f]{1,4}:){0,3}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){2}:([0-9A-Fa-f]{1,4}:){0,4}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){6}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(([0-9A-Fa-f]{1,4}:){0,5}:((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|(::([0-9A-Fa-f]{1,4}:){0,5}((\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b)\.){3}(\b((25[0-5])|(1\d{2})|(2[0-4]\d)|(\d{1,2}))\b))|([0-9A-Fa-f]{1,4}::([0-9A-Fa-f]{1,4}:){0,5}[0-9A-Fa-f]{1,4})|(::([0-9A-Fa-f]@{1,4}:){0,6}[0-9A-Fa-f]{1,4})|(([0-9A-Fa-f]{1,4}:){1,7}:))\b/im
  @@links_regex = %r{
    ((?:https?://|ftps?://|www\d{0,3}\.) # protocol part
    (?:[a-z0-9.\-]*\.?)   # domain[-1] part, greedy up to last .
  #  [a-z]{2,6}  # TLD part old commented, below list from Root Zone Database https://www.iana.org/domains/root/db, only latin names
    (?:aaa|aarp|abarth|abb|abbott|abbvie|abc|able|abogado|abudhabi|academy|accenture|accountant|accountants|ac|aco|active|actor|adac|ad|ads|adult|ae|aeg|aero|aetna|afamilycompany|af|afl|africa|agakhan|ag|agency|ai|aig|aigo|airbus|airforce|airtel|akdn|al|alfaromeo|alibaba|alipay|allfinanz|allstate|ally|alsace|alstom|amazon|am|americanexpress|americanfamily|amex|amfam|amica|amsterdam|analytics|an|android|anquan|anz|ao|aol|apartments|app|apple|aq|aquarelle|arab|aramco|archi|ar|army|arpa|arte|art|as|asda|asia|associates|at|athleta|attorney|au|auction|audible|audi|audio|auspost|author|auto|autos|avianca|aw|aws|axa|ax|az|azure	# A doms
    |baby|ba|baidu|banamex|bananarepublic|band|bank|barcelona|barclaycard|barclays|barefoot|bargains|bar|baseball|basketball|bauhaus|bayern|bbc|bb|bbt|bbva|bcg|bcn|bd|beats|beauty|be|beer|bentley|berlin|bestbuy|best|bet|bf|bg|bharti|bh|bible|bi|bid|bike|bing|bingo|bio|biz|bj|blackfriday|black|blanco|bl|blockbuster|blog|bloomberg|blue|bm|bms|bmw|bn|bnl|bnpparibas|boats|bo|boehringer|bofa|bom|bond|boo|book|booking|boots|bosch|bostik|boston|bot|boutique|box|bq|bradesco|br|bridgestone|broadway|broker|brother|brussels|bs|bt|budapest|bugatti|builders|build|business|buy|buzz|bv|bw|by|bz|bzh	# B doms
    |cab|ca|cafe|cal|call|calvinklein|camera|cam|camp|cancerresearch|canon|capetown|capital|capitalone|caravan|cards|career|careers|care|car|cars|cartier|casa|case|caseih|cash|casino|catering|catholic|cat|cba|cbn|cbre|cbs|cc|cd|ceb|center|ceo|cern|cfa|cf|cfd|cg|chanel|channel|charity|chase|chat|ch|cheap|chintai|chloe|christmas|chrome|chrysler|church|ci|cipriani|circle|cisco|citadel|citic|citi|cityeats|city|ck|claims|cl|cleaning|click|clinic|clinique|clothing|cloud|club|clubmed|cm|cn|coach|co|codes|coffee|college|cologne|comcast|com|commbank|community|company|compare|computer|comsec|condos|construction|consulting|contact|contractors|cookingchannel|cooking|cool|coop|corsica|country|coupon|coupons|courses|cpa|cr|creditcard|credit|creditunion|cricket|crown|crs|cruise|cruises|csc|cu|cuisinella|cv|cw|cx|cy|cymru|cyou|cz	# C doms
    |dabur|dad|dance|data|date|dating|datsun|day|dclk|dds|dealer|deal|deals|de|degree|delivery|dell|deloitte|delta|democrat|dental|dentist|desi|design|dev|dhl|diamonds|diet|digital|direct|directory|discount|discover|dish|diy|dj|dk|dm|dnp|do|docs|doctor|dodge|dog|doha|domains|doosan|dot|download|drive|dtv|dubai|duck|dunlop|duns|dupont|durban|dvag|dvr|dz	# D doms
    |earth|eat|ec|eco|edeka|education|edu|ee|eg|eh|email|emerck|energy|engineer|engineering|enterprises|epost|epson|equipment|er|ericsson|erni|es|esq|estate|esurance|et|etisalat|eu|eurovision|eus|events|everbank|exchange|expert|exposed|express|extraspace	# E doms
    |fage|fail|fairwinds|faith|family|fan|fans|farmers|farm|fashion|fast|fedex|feedback|ferrari|ferrero|fiat|fi|fidelity|fido|film|final|finance|financial|fire|firestone|firmdale|fish|fishing|fit|fitness|fj|fk|flickr|flights|flir|florist|flowers|flsmidth|fly|fm|fo|food|foodnetwork|foo|football|ford|forex|forsale|forum|foundation|fox|fr|free|fresenius|frl|frogans|frontdoor|frontier|ftr|fujitsu|fujixerox|fund|fun|furniture|futbol|fyi	# F doms
    |ga|gal|gallery|gallo|gallup|game|games|gap|garden|gay|gb|gbiz|gd|gdn|gea|ge|gent|genting|george|gf|gg|ggee|gh|gi|gift|gifts|gives|giving|glade|glass|gl|gle|global|globo|gmail|gmbh|gm|gmo|gmx|gn|godaddy|gold|goldpoint|golf|goodhands|goodyear|goo|goog|google|gop|got|gov|gp|gq|grainger|graphics|gratis|gr|green|gripe|grocery|group|gs|gt|guardian|gucci|gu|guge|guide|guitars|guru|gw|gy	# G doms
    |hair|hamburg|hangout|haus|hbo|hdfcbank|hdfc|healthcare|health|help|helsinki|here|hermes|hgtv|hiphop|hisamitsu|hitachi|hiv|hk|hkt|hm|hn|hockey|holdings|holiday|homedepot|homegoods|homesense|homes|honda|honeywell|horse|hospital|host|hosting|hoteles|hotels|hot|hotmail|house|how|hr|hsbc|htc|ht|hu|hughes|hyatt|hyundai	# H doms
    |ibm|icbc|ice|icu|id|ie|ieee|ifm|iinet|ikano|il|imamat|im|imdb|immobilien|immo|inc|in|industries|infiniti|info|ing|ink|institute|insurance|insure|intel|international|int|intuit|investments|io|ipiranga|iq|ir|irish|is|iselect|ismaili|istanbul|ist|itau|it|itv|iveco|iwc	# I doms
    |jaguar|java|jcb|jcp|je|jeep|jetzt|jewelry|jio|jlc|jll|jm|jmp|jnj|jobs|joburg|jo|jot|joy|jp|jpmorgan|jprs|juegos|juniper	# J doms
    |kaufen|kddi|ke|kerryhotels|kerrylogistics|kerryproperties|kfh|kg|kh|kia|ki|kim|kinder|kindle|kitchen|kiwi|km|kn|koeln|komatsu|kosher|kp|kpmg|kpn|kr|krd|kred|kuokgroup|kw|ky|kyoto|kz	# K doms
    |lacaixa|la|ladbrokes|lamborghini|lamer|lancaster|lancia|lancome|land|landrover|lanxess|lasalle|lat|latino|latrobe|law|lawyer|lb|lc|lds|lease|leclerc|lefrak|legal|lego|lexus|lgbt|liaison|li|lidl|life|lifeinsurance|lifestyle|lighting|like|lilly|limited|limo|lincoln|linde|link|lipsy|live|living|lixil|lk|llc|llp|loan|loans|locker|locus|loft|lol|london|lotte|lotto|love|lplfinancial|lpl|lr|ls|lt|ltda|ltd|lu|lundbeck|lupin|luxe|luxury|lv|ly	# L doms
    |ma|macys|madrid|maif|maison|makeup|management|man|mango|map|market|marketing|markets|marriott|marshalls|maserati|mattel|mba|mc|mcd|mcdonalds|mckinsey|md|me|med|media|meet|melbourne|meme|memorial|men|menu|meo|merckmsd|metlife|mf|mg|mh|miami|microsoft|mil|mini|mint|mit|mitsubishi|mk|mlb|ml|mls|mma|mm|mn|mobi|mobile|mobily|mo|moda|moe|moi|mom|monash|money|monster|montblanc|mopar|mormon|mortgage|moscow|moto|motorcycles|mov|movie|movistar|mp|mq|mr|ms|msd|mt|mtn|mtpc|mtr|mu|museum|music|mutual|mutuelle|mv|mw|mx|my|mz	# M doms
    |nab|na|nadex|nagoya|name|nationwide|natura|navy|nba|nc|nec|ne|netbank|netflix|net|network|neustar|new|newholland|news|nextdirect|next|nexus|nf|nfl|ng|ngo|nhk|nico|ni|nike|nikon|ninja|nissan|nissay|nl|no|nokia|northwesternmutual|norton|now|nowruz|nowtv|np|nra|nr|nrw|ntt|nu|nyc|nz	# N doms
    |obi|observer|off|office|okinawa|olayan|olayangroup|oldnavy|ollo|om|omega|one|ong|onl|online|onyourside|ooo|open|oracle|orange|organic|org|orientexpress|origins|osaka|otsuka|ott|ovh	# O doms
    |pa|page|pamperedchef|panasonic|panerai|paris|pars|partners|parts|party|passagens|pay|pccw|pe|pet|pf|pfizer|pg|pharmacy|ph|phd|philips|phone|photo|photography|photos|physio|piaget|pics|pictet|pictures|pid|pin|ping|pink|pioneer|pizza|pk|place|play|playstation|pl|plumbing|plus|pm|pnc|pn|pohl|poker|politie|porn|post|pramerica|praxi|pr|press|prime|prod|productions|prof|pro|progressive|promo|properties|property|protection|prudential|pru|ps|pt|pub|pwc|pw|py	# P doms
    |qa|qpon|quebec|quest|qvc	# Q doms
    |racing|radio|raid|read|realestate|realtor|realty|recipes|re|red|redstone|redumbrella|rehab|reise|reisen|reit|reliance|ren|rentals|rent|repair|report|republican|restaurant|rest|review|reviews|rexroth|richardli|rich|ricoh|rightathome|ril|rio|rip|rmit|rocher|rocks|ro|rodeo|rogers|room|rs|rsvp|ru|rugby|ruhr|run|rw|rwe|ryukyu	# R doms
    |saarland|sa|safe|safety|sakura|sale|salon|samsclub|samsung|sandvikcoromant|sandvik|sanofi|sap|sapo|sarl|sas|save|saxo|sb|sbi|sbs|sca|scb|sc|schaeffler|schmidt|scholarships|school|schule|schwarz|science|scjohnson|scor|scot|sd|search|seat|se|secure|security|seek|select|sener|services|ses|seven|sew|sex|sexy|sfr|sg|shangrila|sharp|shaw|sh|shell|shia|shiksha|shoes|shop|shopping|shouji|show|showtime|shriram|si|silk|sina|singles|site|sj|sk|ski|skin|sky|skype|sl|sling|smart|sm|smile|sncf|sn|soccer|social|so|softbank|software|sohu|solar|solutions|song|sony|soy|space|spa|spiegel|sport|spot|spreadbetting|sr|srl|srt|ss|stada|staples|star|starhub|statebank|statefarm|statoil|stc|stcgroup|st|stockholm|storage|store|stream|studio|study|style|sucks|su|supplies|supply|support|surf|surgery|suzuki|sv|swatch|swiftcover|swiss|sx|sy|sydney|symantec|systems|sz	# S doms
    |tab|taipei|talk|taobao|target|tatamotors|tatar|tattoo|tax|taxi|tc|tci|td|tdk|team|tech|technology|telecity|telefonica|tel|temasek|tennis|테스트|teva|tf|tg|th|thd|theater|theatre|tiaa|tickets|tienda|tiffany|tips|tires|tirol|tj|tjmaxx|tjx|tk|tkmaxx|tl|tmall|tm|tn|to|today|tokyo|tools|top|toray|toshiba|total|tours|town|toyota|toys|tp|trade|trading|training|travelchannel|travelers|travelersinsurance|travel|tr|trust|trv|tt|tube|tui|tunes|tushu|tv|tvs|tw|tz	# T doms
    |ua|ubank|ubs|uconnect|ug|uk|um|unicom|university|uno|uol|ups|us|uy|uz	# U doms
    |vacations|va|vana|vanguard|vc|ve|vegas|ventures|verisign|vermögensberater|vermögensberatung|versicherung|vet|vg|viajes|vi|video|vig|viking|villas|vin|vip|virgin|visa|vision|vista|vistaprint|viva|vivo|vlaanderen|vn|vodka|volkswagen|volvo|vote|voting|voto|voyage|vu|vuelos	# V doms
    |wales|walmart|walter|wang|wanggou|warman|watches|watch|weatherchannel|weather|webcam|weber|website|wedding|wed|weibo|weir|wf|whoswho|wien|wiki|williamhill|windows|wine|win|winners|wme|wolterskluwer|woodside|work|works|world|wow|ws|wtc|wtf	# W doms
    |xbox|xerox|xfinity|xihuan|xin|xperia|xxx|xyz	# X doms
    |yachts|yahoo|yamaxun|yandex|ye|yodobashi|yoga|yokohama|you|youtube|yt|yun	# Y doms
    |za|zappos|zara|zero|zip|zippo|zm|zone|zuerich|zw)	# Z doms
    (?:/*[^\s()<>`!{}:;'"\[\]]*))  # link path
  }xim
  @@money_regex = /(((^|\b)US?)?\$\s?[0-9]{1,3}((,[0-9]{3})+|([0-9]{3})+)?(\.[0-9]{1,2})?\b)/m
  @@percentages_regex = /((100(\.0+)?|[0-9]{1,2}(\.[0-9]+)?)%)/m
  @@phones_regex = /(\d?[^\s\w]*(?:\(?\d{3}\)?\W*)?\d{3}\W*\d{4})/im
  @@times_regex = /\b((0?[0-9]|1[0-2])(:[0-5][0-9])?(am|pm)|([01]?[0-9]|2[0-3]):[0-5][0-9])/im

  METHODS.each do |regex_name|
    define_method "get_#{regex_name}" do
      self.class.send "get_#{regex_name}", @text
    end

    define_singleton_method "get_#{regex_name}" do |text|
      get_matches text, instance_eval("@@#{regex_name}_regex")
    end
  end

  private
    def self.get_matches(text, regex)
      text.scan(regex).collect{|x| x[0]}
    end
end
