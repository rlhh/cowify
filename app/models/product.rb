# == Schema Information
#
# Table name: products
#
#  id           :integer          not null, primary key
#  available    :boolean          default(FALSE), not null
#  cowboom_id   :integer          not null
#  name         :string(255)      not null
#  static_image :string(255)      not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Product < ActiveRecord::Base
  has_many :lots

  validates :available,     presence: true
  validates :cowboom_id,    presence: true
  validates :name,          presence: true
  validates :static_image,  presence: true

  before_validation :get_product_details, on: :create
  after_create :get_lots

  def get_product_details
    @agent = Mechanize.new

    #product title
    page = @agent.get(CONFIG[:cowboom_product_url] + self.cowboom_id.to_s)
    doc = page.parser

    name = doc.search('h1.product-profile-title').text.strip

    static_image = doc.xpath("//div[@id='productImage2']/img").attr('src').text unless doc.xpath("//div[@id='productImage2']/img").empty?

    #preowned = page.search('div.ProdDetailTable').text

    unless name.empty?
      self.name = name
      self.available = true
      self.static_image = static_image

      Lot.where(product_id: self.cowboom_id).update_all("active = false")
    end
  end

  def get_lots
    page_no = 1
    page = @agent.get(CONFIG[:cowboom_best_available_base_url] + self.cowboom_id.to_s + CONFIG[:cowboom_best_available_page] + page_no.to_s)
    doc = page.parser

    num_of_products_in_page = doc.search('div.rtLbl').size
    while( num_of_products_in_page != 0 )

      for i in 0..(num_of_products_in_page-1) do
        begin
          row_no = i + 1
          text =  doc.search('div.rtLbl')[i].text
          notes_exist = doc.xpath("//div[@class='rtLbl']/b[1]")[i]

          if( notes_exist != nil && notes_exist.text.strip == "Notes:" )
            notes = text.split("Notes:")[1].split("What's Included")[0].strip
            #puts notes
          else
            notes = ""
          end

          included = text.split("What's Included:")[1].split("Not Included")[0].
              strip.gsub( /\r\n/, " ").gsub( /\t/, "" ).gsub(",      ", ",")

          not_included = text.split("Not Included:")[1].split("Item Location:")[0].
              strip.gsub( /\r\n/, " ").gsub( /\t/, "" ).gsub(",           ", ",")

          location = text.split("Item Location:")[1].split("Product Grade:")[0].strip

          grade = text.split("Product Grade:")[1].strip
          grade_num = grade[0]

          price = doc.xpath("//div[@class='ProdPrice']")[i].text.tr('^0-9.', "")

          content_id = doc.search('input')[4+(i*9)].attr('value')
          lot_id = doc.search('input')[5+(i*9)].attr('value')

          image = doc.search( 'div > a > img > @src' )[i].text.gsub("/thumb", "")

          lot = Lot.where(product_id: self.id,
                          cowboom_lot_id: lot_id).first_or_create(content_id: content_id, price: price, grade: grade,
                                                                  grade_num: grade_num, included: included,
                                                                  not_included: not_included, location: location,
                                                                  notes: notes, active: true, image: image,
                                                                  page: page_no, row: row_no)

          unless lot.new_record?
            lot.update_attributes(:active=>true, :page=>page_no, :row=>row_no)
          end

        rescue Exception => e # Or just handle particular exceptions
          puts "Failed at: " + Time.now.utc.to_s(:long)
          puts "  #{e}"

        end
      end

      page_no += 1
      page = @agent.get(CONFIG[:cowboom_best_available_base_url] + self.cowboom_id.to_s + CONFIG[:cowboom_best_available_page] + page_no.to_s)
      doc = page.parser
      num_of_products_in_page = doc.search('div.rtLbl').size
    end
  end

end
