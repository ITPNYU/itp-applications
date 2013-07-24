class Post
  include DataMapper::Resource

  property :id, Serial, key: true
  property :created_at, DateTime
  property :updated_at, DateTime
  property :published_at, DateTime
  property :active, Boolean, default: true
  property :draft, Boolean, default: true

  property :title, String, length: 255
  property :content, Text
  property :coords, String

  property :user_id, Integer, required: true
  property :assignment_id, Integer, required: false

  belongs_to :assignment
  belongs_to :user

  has n, :responses, self, :child_key => [:original_id]
  belongs_to :original, self, :required => false

  self.per_page = 10

  before :save do
    publish
  end

  #############################################################################
  #
  # CLASS METHODS
  #
  #############################################################################

  # Public: Return all active resources marked as drafts, sorted in reverse
  # chronological order by updated_at.
  #
  # Returns a DataMapper Collection.
  def self.drafts
    all(draft: true, active: true, order: :updated_at.desc)
  end

  # Public: Return all active resources marked as published, sorted in reverse
  # chronological order by published time.
  #
  # Returns a DataMapper Collection.
  def self.published
    all(draft: false, active: true, order: :published_at.desc)
  end

  def self.active
    all(active: true)
  end

  #############################################################################
  #
  # INSTANCE METHODS
  #
  #############################################################################

  # Public: Instead of removing a model from the DB, mark it as inactive. This
  # is to make deletions recoverable and make it unnecessary to detach all
  # associations before deletion.
  #
  # Returns the result of the update call.
  def delete
    self.update(active: false)
  end

  # Public: Returns a string representing the path to this resource.
  #
  # Returns a string.
  def url
    "/students/#{self.user.netid}/#{self.id}"
  end

  def edit_url
    "/students/#{self.id}/edit"
  end

  private

  # Private: Sets published date if resource is saved with draft==false. Will
  # only set the publish date on the first save unless resource is unpublished.
  # If a resource is a draft, unset published_at.
  def publish
    self.title = "Untitled" if self.title == ""

    if self.draft
      self.published_at = nil
    else
      self.published_at ||= DateTime.now
    end
  end
end