class Article < ApplicationRecord
  belongs_to :user
  has_many :favorites

  include AASM

  aasm do
    state :not_published, initial: true
    state :published

    event :publish do
      transitions from: :not_published, to: :published
    end
  end

  scope :written_by, -> (user_id) { where(user_id: user_id) }
  scope :authors, -> { all.map(&:user).uniq }
end
