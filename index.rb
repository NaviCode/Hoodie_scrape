require 'HTTParty'
require 'Nokogiri'
require 'JSON'
require 'pry'
require 'csv'
require 'watir'

$website = "http://btsofficialshop.com/shop/shopdetail.html?branduid=1101244&xcode=004&mcode=009&scode=&type=Y&sort=manual&cur_code=004009&GfDT=Zmt3U1U%3D"

def open_browser
    browser = Watir::Browser.new :firefox
    browser.goto $website
end

begin
    while true
        page = HTTParty.get($website)
        parse_page = Nokogiri::HTML(page)

        filter_page = parse_page.css('.col-xs-5').text.gsub(/\s+/,"")
        sold_out = filter_page.include? "Soldout"

        unless sold_out === false
            puts "Sold out @ #{Time.now}"
            CSV.open('log.csv','w') do |csv|
                csv << ["Sold out @ #{Time.now}"]
            end
        else
            open_browser
            break
        end
    end
rescue Interrupt => e
    puts "good-bye"
end
    


