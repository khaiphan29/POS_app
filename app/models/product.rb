class Product < ApplicationRecord
  belongs_to :category
  has_one_attached :image, dependent: :purge_later do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 300, 300 ]
    attachable.variant :detail, resize_to_limit: [ 1080, 1080 ]
  end
  has_many :order_items
  has_many :orders, through: :order_items

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  after_commit :resize_image, on: :create

  private

  def resize_image
    return unless image.attached?

    # Resize the image to 1080x1080 before storing
    image.variant(resize_to_limit: [ 1080, 1080 ]).processed
  end
end
