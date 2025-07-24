class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
    if turbo_frame_request?
      render partial: "form", locals: { product: @product }
    else
      render :edit
    end
  end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html do
          if turbo_frame_request?
            render partial: "product", locals: { product: @product }
          else
            redirect_to products_path, notice: "Product was successfully created."
          end
        end
      else
        format.html do
          if turbo_frame_request?
            render partial: "form", locals: { product: @product }, status: :unprocessable_entity
          else
            render :new, status: :unprocessable_entity
          end
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html do
          if turbo_frame_request?
            render partial: "product", locals: { product: @product }
          else
            redirect_to products_path, notice: "Product was successfully updated."
          end
        end
      else
        format.html do
          if turbo_frame_request?
            render partial: "form", locals: { product: @product }, status: :unprocessable_entity
          else
            render :edit, status: :unprocessable_entity
          end
        end
      end
    end
  end

  def destroy
    @product.destroy!

    respond_to do |format|
      format.html do
        if turbo_frame_request?
          head :no_content
        else
          redirect_to products_path, status: :see_other, notice: "Product was successfully destroyed."
        end
      end
      format.json { head :no_content }
    end
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :price)
    end
end
