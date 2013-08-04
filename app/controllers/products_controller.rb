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

class ProductsController < ApplicationController
  #actions :all, except: [ :destroy ]

  def index
    @products = Product.all.paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html # index.html.erb
                  #format.json { render json: @products }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
                  #format.json { render json: @product }
    end
  end

  def create
    cowboom_id = params[:product][:cowboom_id].sub(/^https?\:\/\//, '').sub(/^www./,'').sub(/cowboom.com\/product\//, '')

    @product = Product.where(cowboom_id: cowboom_id).first_or_create

    if not @product.new_record?
      redirect_to @product
    elsif @product.save
      redirect_to @product
    else
      render action: "new"
    end
  end

  private
  def product_params
    params.require(:product).permit(:available, :cowboom_id, :name, :static_image)
  end
end
