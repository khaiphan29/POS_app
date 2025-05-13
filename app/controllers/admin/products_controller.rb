class Admin::ProductsController < Admin::BaseController
  layout "admin"

  def index
    @parent_categories = Category.where(parent_id: nil).where.not(name: DUMP_CATEGORY)
    @child_categories = child_categories
    @dump_category = Category.find_by(name: DUMP_CATEGORY)
    @products_count = Product.count
    @new_product = Product.new
  end

  def new
    @categories = Category.all
    @new_product = Product.new
    render partial: "form", locals: { product: @new_product, child_categories: child_categories, heading: "Tạo sản phẩm mới", url: admin_products_path }
  end

  def create
    if !Category.find(product_params[:category_id]).parent.present?
      flash[:error] = "Danh mục không hợp lệ"
      redirect_to admin_products_path
      return
    end

    @product = Product.new(product_params)
    if @product.save
      flash[:success] = "Tạo thành công"
    else
      # flash[:error] = "Lỗi khi tạo sản phẩm"
      flash[:error] = @product.errors.full_messages.join(", ")
    end
    redirect_to admin_products_path
  end

  def edit
    @product = Product.find(params[:id])
    @categories = Category.all
    render partial: "form", locals: { product: @product, child_categories: child_categories, heading: "Chỉnh sửa sản phẩm", url: admin_product_path(@product) }
  end

  def update
    if !Category.find(product_params[:category_id]).parent.present?
      flash[:error] = "Danh mục không hợp lệ"
      redirect_to admin_products_path
      return
    end

    @product = Product.find(params[:id])
    # Check if a new image is being uploaded
    if params[:product][:image].present?
      # Purge the old image if one exists
      @product.image.purge if @product.image.attached?
    end

    if @product.update(product_params)
      flash[:success] = "Chỉnh sửa thành công"
    else
      flash[:error] = "Lỗi khi tạo sản phẩm"
    end
    redirect_to admin_products_path
  end

  def destroy
    @product = Product.find(params[:id])
    @dump_category = Category.find_by(name: DUMP_CATEGORY)
    if @product.update(category: @dump_category)
      flash[:success] = "Xóa thành công"
    else
      flash[:error] = "Lỗi khi xóa sản phẩm"
    end
    redirect_to admin_products_path
  end

  # def destroy
  #   @product = Product.find(params[:id])
  #   if params[:product][:image].present?
  #     # Purge the old image if one exists
  #     @product.image.purge if @product.image.attached?
  #   end
  #
  #   @product.destroy
  #   redirect_to admin_products_path
  # end

  private

  def product_params
    permitted_params = params.require(:product).permit(:name, :description, :price, :category_id, :image)
    permitted_params.delete(:image) if permitted_params[:image].blank?
    permitted_params
  end

  def child_categories
    Category.where.not(parent_id: nil)
  end
end
