class Post < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :votes,    dependent: :destroy
  belongs_to :user
  belongs_to :subreddit

  attr_accessor :sub

  before_validation :process_link
  before_save :clean_up_post_for_database, :process_thumbnail

  validates :title, presence: true,
                    length: { maximum: 255 }

  validates :link, presence: true

  validates :post_type, presence: true,
                        inclusion: { in: [ 0, 1 ] }

  def karma
    self.upvotes - self.downvotes
  end

  protected

    def process_link
      return link if link.blank?
      if self.post_type == 0
        self.link = "/r/#{self.subreddit.name}/#{self.id}"
      else
        self.link = add_scheme_to_link(URI.parse(self.link)).to_s
      end
    end

    def clean_up_post_for_database
      bad_chars_regex = /[\t|\n|\r|\f|\b|\a|\v]/

      self.title = self.title.gsub(bad_chars_regex, " ")
      self.link  = self.link.gsub(bad_chars_regex, " ") unless self.link.nil?
      self.post_text = nil if self.post_type == 1
    end

    def process_thumbnail
      # A post shouldn't fail because of a bad thumbnail, as it isn't user populated.
      # So this is really just in case a user messes with the form.
      begin
        thumb = URI.parse(self.thumbnail)
        unless ["http", "https"].include? thumb.scheme
          self.thumbnail = nil
        end
      rescue
        self.thumbnail = nil
      end
    end
end
