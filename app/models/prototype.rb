class Prototype < ApplicationRecord
  has_many :comments
  belongs_to :user
  has_one_attached :image

  validates :title, presence: true
  validates :catch_copy, presence: true
  validates :concept, presence: true

  def was_attached?
    self.image.attached?
  end

end
