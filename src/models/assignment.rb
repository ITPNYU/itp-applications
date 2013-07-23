class Assignment
  include DataMapper::Resource

  property :id, Serial
  property :created_at, DateTime
  property :updated_at, DateTime
  property :active, Boolean, default: true
  property :year, Integer, default: DateTime.now.year, writer: :private

  property :title, String, length: 255
  property :content, Text
  property :draft, Boolean, default: true
  property :published_at, DateTime

  has n, :posts

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

  def self.all_active
    all(:active => true)
  end

  # Public: Get 1 model by ID and ensure that it is active.
  def self.get_active(id)
    first(:id => id, :active => true)
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
    "/assignments/#{self.year}/#{self.id}"
  end

  private

  # Private: Sets published date if resource is saved with draft==false. Will
  # only set the publish date on the first save unless resource is unpublished.
  # If a resource is a draft, unset published_at.
  def publish
    if self.draft == false && self.published_at.nil?
      self.published_at = DateTime.now
    else
      self.published_at = nil
    end
  end
end