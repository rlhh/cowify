ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'development'
require File.expand_path(File.dirname(__FILE__) + "/../cowndex/config/environment")

require 'rubygems'
require 'mechanize'

$BEST_AVAIL_URL = "http://www.cowboom.com/store/ProductBestAvailable.cfm?contentID="
$PAGE_URL = "&pageno="
$PRODUCT_URL = "http://www.cowboom.com/product/"

#product_ID = 744234

def scrape( product_ID )

		agent = Mechanize.new
		page_no = 1

		#product title
		page = agent.get($PRODUCT_URL + product_ID.to_s)
		doc = page.parser
		name = doc.search('h1.product-profile-title').text.strip
    #image = doc.xpath("//div[@id='productImage2']/img").attr('src').text

    if( !name.empty? )
      product = Product.create( :name => name,
                              :item_ID => product_ID,
                              :available => true )

      #Best available
      page = agent.get($BEST_AVAIL_URL + product_ID.to_s + $PAGE_URL + page_no.to_s)
      doc = page.parser

      products_in_page = doc.search('div.rtLbl').size

      while( products_in_page != 0 )
        #puts page_no
        for i in 0..(products_in_page-1) do
          begin
            row_no = i+1
            #puts row_no
            notes_exist = doc.xpath("//div[@class='rtLbl']/b[1]")[i]

            if( notes_exist != nil && notes_exist.text.strip == "Notes:" )
              #notes = doc.xpath("//div[@class='rtLbl']/text()[2]")[i].text
              index = 2
              notes = doc.xpath("//div[@class='rtLbl']/text()[2]")[i].text.strip
              notes = notes.strip
              puts notes
            else
              index = 1
            end

            puts i
            puts index

            #included = doc.xpath("//div[@class='rtLbl']/text()[3]")[i].text.strip
            included = doc.xpath("//div[@class='rtLbl']/text()[#{index}+1]")[i].text
            included = included.gsub( /\r\n/, " ").gsub( /\t/, "" ).gsub(/\u00A0/, "").gsub(",      ", ",").strip

            #puts included

            not_included = doc.xpath("//div[@class='rtLbl']/text()[#{index}+2]")[i].text
            not_included = not_included.gsub( /\r\n/, "").gsub( /\t/, "" ).gsub(/\u00A0/, "").gsub(",      ", ",").strip

            #puts not_included

            location = doc.xpath("//div[@class='rtLbl']/text()[#{index}+3]")[i].text
            location = location.gsub( /\r\n/, " ").gsub( /\t/, "" ).gsub(/\u00A0/, "").gsub(" ", "")

            #puts location

            grade = doc.xpath("//div[@class='rtLbl']/text()[#{index}+4]")[i].text.strip
            grade_num = grade[0]

            puts grade
            #puts grade_num

            price = doc.xpath("//div[@class='ProdPrice']")[i].text.tr('^0-9.', "")

            #content_ID = doc.search('input')[3+(i-1)*9].attr('value')
            content_ID = doc.search('input')[4].attr('value')
            #lot_ID = doc.search('input')[4+(i-1)*9].attr('value')
            lot_ID = doc.search('input')[5].attr('value')

            #puts content_ID
            puts lot_ID

            #image = doc.search( 'div > a > img > @src' )[i].text.gsub("/thumb", "")
            image = doc.search( 'div > a > img > @src' )[i].text.gsub("/thumb", "")

            #puts image

            Lot.create( :content_ID => content_ID,
                        :inventory_ID => lot_ID,
                        :product_id => product.id,
                        :grade => grade,
                        :grade_num => grade_num,
                        :price => price,
                        :included => included,
                        :not_included => not_included,
                        :notes => notes,
                        :location => location,
                        :image => image,
                        :page => page_no,
                        :row => row_no,
                        :active => true )

          # rescue Exception => e # Or just handle particular exceptions
           # puts "Failed at: " + Time.now.utc.to_s(:long)
           # puts "  #{e}"

          end
        end

        page_no += 1
        page = agent.get($BEST_AVAIL_URL + product_ID.to_s + $PAGE_URL + page_no.to_s)
        doc = page.parser
        products_in_page = doc.search('div.rtLbl').size
      end
    end
end


#Name		
#Notes
#Included
#not_included
#Location
#Grade
#grade_num
#Price
#Content_ID
#Lot_ID
#Image
#Page_no
#Row_no