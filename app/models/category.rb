class Category < ApplicationRecord
  belongs_to :parent, class_name: "Category", optional: true
  has_many :children, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  has_many :products

  validates :name, presence: true, uniqueness: true
  validate :parent_must_be_root

  default_scope { order(:name) }

  def product_count
    Product.where(category_id: children.pluck(:id)).count
  end

  def parent_must_be_root
    if parent.present?
      if parent.parent.present?
        errors.add(:parent, "must be a root category (cannot have a grandparent)")
      elsif parent_id == id
        errors.add(:parent, "cannot be the same as the category itself")
      end
    end
  end
end
