class Post < ApplicationRecord
  has_many :comments
  belongs_to :user
  belongs_to :subreddit, dependent: :destroy

  DEFAULT_THUMBNAIL = "http://i.imgur.com/D6QAHtY.jpg"

  attr_accessor :sub

  before_validation :process_link
  before_save :clean_up_post_for_database, :process_thumbnail

  validates :title, presence: true,
                    length: { maximum: 255 }

  validates :link, format: { with: URI::regexp(["http", "https"]) },
                   presence: true, if: "post_type == 1"

  validates :post_type, presence: true,
                        inclusion: { in: [ 0, 1 ] }

  def karma
    self.upvotes - self.downvotes
  end

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

    def process_thumbnail
      # A post shouldn't fail because of a bad thumbnail, as it isn't user populated.
      # So this is really just in case a user messes with the form.
      begin
        thumb = URI.parse(self.thumbnail)
        unless ["http", "https"].include? thumb.scheme
          self.thumbnail = DEFAULT_THUMBNAIL
        end
      rescue
        self.thumbnail = DEFAULT_THUMBNAIL
      end
    end
end
