class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  scope :latest_posts, ->{order created_at: :desc}
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.post_length}
  validates :image,
            content_type: {in: %w(image/jpeg image/gif image/png),
                           message: I18n.t("img_valid")},
                           size: {less_than: Settings.img_data_size.megabytes,
                                  message: I18n.t("img_size")}
  def display_image
    image.variant resize_to_limit: Settings.img_size
  end
end
