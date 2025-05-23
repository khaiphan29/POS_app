class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  # Ensure quantity defaults to 0 if nil
  after_initialize :set_defaults, if: :new_record?

  private

  def set_defaults
    self.quantity ||= 0
  end
end
