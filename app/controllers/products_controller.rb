class ProductsController < ApplicationController

  def index
    @products = Product.all

    respond_to do |format|
      format.html # index.html.erb
                  #format.json { render json: @products }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find_by_id(params[:id])

    respond_to do |format|
      format.html # show.html.erb
                  #format.json { render json: @product }
    end
  end

  # POST /obtain/1
  def obtain
    scrapy = Scraper.new  
    
    @product = scrapy.scrape((params[:pid]))
    
    if @product
      redirect_to @product, notice: 'Product successfully updated'
    elsif
      redirect_to root_path, notice: 'Invalid product requested'
    end
  end
  
end
