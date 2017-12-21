# == Schema Information
#
# Table name: shortened_urls
#
#  id         :integer          not null, primary key
#  long_url   :string           not null
#  short_url  :string
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ShortenedUrl < ApplicationRecord
  validates :long_url, presence: true, uniqueness: true
  validates :user_id, presence: true

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  has_many :visits,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :Visit

  has_many :visitors,
    through: :visits,
    source: :user

  def self.random_code
    random_code = SecureRandom::urlsafe_base64(16)
    while self.exists?(:short_url => random_code)
      random_code = SecureRandom::urlsafe_base64(16)
    end
    random_code
  end

  def self.createUrl(user, long_url)
    random_code = self.random_code
    self.create!(short_url: random_code, user_id: user.id, long_url: long_url)
  end

  def num_clicks
    self.visits.length
  end

  def num_uniques
    self.visitors.uniq
  end

  def num_recent_uniques
    Visit.all.select do |visit|
      visit.user_id == self.id && visit.created_at < 10.minutes.ago
    end
  end


end
