# Controller for Category
class Admin::CategoriesController < Admin::BaseController
  layout "admin"

  def index
    @categories = Category.where(parent_id: nil).where.not(name: DUMP_CATEGORY).eager_load(:children)
    @new_category = Category.new
  end

  def new
    @category = Category.new
    @parent_categories = Category.where(parent_id: nil).where.not(name: DUMP_CATEGORY)
    respond_to do |format|
      format.html { render partial: "form", locals: { category: @category, pareent_categories: @parent_categories } }
      format.js
    end
  end

  def edit
    @category = Category.find(params[:id])
    @parent_categories = Category.where.not(id: @category.id).where(parent_id: nil).where.not(name: DUMP_CATEGORY)
    respond_to do |format|
      format.html { render partial: "form", locals: { category: @category, pareent_categories: @parent_categories } }
      format.json { render json: @category }
      format.js
    end
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "Tạo thành công"
    else
      flash[:error] = "Lỗi khi tạo danh mục"
    end
    redirect_to admin_categories_path
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to admin_categories_path
    else
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    predefined_category = Category.find_by(name: DUMP_CATEGORY) # Replace with your predefined category logic

    if predefined_category
      @category.products.update_all(category_id: predefined_category.id) # Reassign products
      @category.destroy
    end

    redirect_to admin_categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name, :parent_id)
  end
end
