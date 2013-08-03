ENV['RAILS_ENV'] = ARGV.first || ENV['RAILS_ENV'] || 'development'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

require 'rubygems'
require 'mechanize'

$BEST_AVAIL_URL = "http://www.cowboom.com/store/ProductBestAvailable.cfm?contentID="
$PAGE_URL = "&pageno="
$PRODUCT_URL = "http://www.cowboom.com/product/"

#product_ID = 744234

class Scraper
  def scrape( product_ID )

    agent = Mechanize.new
    page_no = 1

    #product title
    page = agent.get($PRODUCT_URL + product_ID.to_s)
    doc = page.parser
    name = doc.search('h1.product-profile-title').text.strip
    static_image = doc.xpath("//div[@id='productImage2']/img").attr('src').text

    preowned = page.search('div.ProdDetailTable').text
    preowned.include?('Pre-owned')

    if( !name.empty? && preowned.include?('Pre-owned') )
      product = Product.create( :name => name,
                              :item_ID => product_ID,
                              :available => true,
                              :static_image => static_image )

      Product.find_by_item_ID(product_ID).lots.update_all("active = false")
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

            text =  doc.search('div.rtLbl')[i].text

            notes_exist = doc.xpath("//div[@class='rtLbl']/b[1]")[i]
            #puts notes_exist.text.strip

            if( notes_exist != nil && notes_exist.text.strip == "Notes:" )
              notes = text.split("Notes:")[1].split("What's Included")[0].strip
              #puts notes
            else
              notes = ""
            end

            #puts i

            included = text.split("What's Included:")[1].split("Not Included")[0].
                strip.gsub( /\r\n/, " ").gsub( /\t/, "" ).gsub(",      ", ",")
            #puts included

            not_included = text.split("Not Included:")[1].split("Item Location:")[0].
                strip.gsub( /\r\n/, " ").gsub( /\t/, "" ).gsub(",           ", ",")
            #puts not_included

            location = text.split("Item Location:")[1].split("Product Grade:")[0].strip

            #puts location

            grade = text.split("Product Grade:")[1].strip
            grade_num = grade[0]

            #puts grade
            #puts grade_num

            price = doc.xpath("//div[@class='ProdPrice']")[i].text.tr('^0-9.', "")

            #content_ID = doc.search('input')[3+(i-1)*9].attr('value')
            content_ID = doc.search('input')[4+(i*9)].attr('value')
            #lot_ID = doc.search('input')[4+(i-1)*9].attr('value')
            lot_ID = doc.search('input')[5+(i*9)].attr('value')

            #puts content_ID
            #puts lot_ID

            #image = doc.search( 'div > a > img > @src' )[i].text.gsub("/thumb", "")
            image = doc.search( 'div > a > img > @src' )[i].text.gsub("/thumb", "")

            #puts image

            if( !Lot.exists?(:inventory_ID => lot_ID) )
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
              debugger
            else
              Lot.find_by_inventory_ID(lot_ID).update_attributes(:active=>true, :page=>page_no, :row=>row_no)
            end

            rescue Exception => e # Or just handle particular exceptions
              puts "Failed at: " + Time.now.utc.to_s(:long)
              puts "  #{e}"

            end
          end

          page_no += 1
          page = agent.get($BEST_AVAIL_URL + product_ID.to_s + $PAGE_URL + page_no.to_s)
          doc = page.parser
          products_in_page = doc.search('div.rtLbl').size
        end
      end
     return Product.find_by_item_ID(product_ID)
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
