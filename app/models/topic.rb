class Topic < ActiveRecord::Base
  has_many :convos
  validates :name, presence: true

  before_validation :create_slug
  validates :slug, presence: true, uniqueness: { case_sensitive: false }

  def to_param
  	slug
  end

  private
    def create_slug
      self.slug = name.parameterize
    end
end
