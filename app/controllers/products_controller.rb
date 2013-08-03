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
    result = Product.all
    @products = result.paginate(:page => (result.size/10)+1, :per_page => 1)

    respond_to do |format|
      format.html # index.html.erb
                  #format.json { render json: @products }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    result = Product.find_by_id(params[:id])
    @products = result.paginate(:page => (result.size/10)+1, :per_page => 1)

    respond_to do |format|
      format.html # show.html.erb
                  #format.json { render json: @product }
    end
  end

  def create
    @product = Product.new(cowboom_id: params[:product][:cowboom_id])

    if @product.save
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
