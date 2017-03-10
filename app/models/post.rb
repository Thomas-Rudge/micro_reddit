class Post < ApplicationRecord
  has_many :comments
  belongs_to :user
  belongs_to :subreddit, dependent: :destroy

  attr_accessor :sub

  before_validation :process_link
  before_save :clean_up_post_for_database

  validates :title, presence: true,
                    length: { maximum: 255 }

  validates :link, format: { with: URI::regexp(["http", "https"]) },
                   presence: true, if: "post_type == 1"

  validates :post_type, presence: true,
                        inclusion: { in: [ 0, 1 ] }

  protected

    def process_link
      return link if link.blank?
      self.link = add_scheme_to_link(URI.parse(self.link)).to_s
    end

    def clean_up_post_for_database
      bad_chars_regex = /[\t|\n|\r|\f|\b|\a|\v]/

      self.title = self.title.gsub(bad_chars_regex, " ")
      self.link  = self.link.gsub(bad_chars_regex, " ") unless self.link.nil?
      self.post_type == 0 ? self.link = nil : self.post_text = nil
    end
end
