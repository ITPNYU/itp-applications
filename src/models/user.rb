require 'bcrypt'

class User
  include DataMapper::Resource
  include BCrypt

  property :id, Serial
  property :created_at, DateTime
  property :updated_at, DateTime
  property :netid, String, length: 32
  property :first_name, String, length: 128
  property :last_name, String, length: 128
  property :preferred_first, String, length: 128
  property :preferred_last, String, length: 128
  property :password_hash, BCryptHash
  property :year, Integer, default: Date.today.year
  property :role, String, default: "provisional"

  has n, :posts

  #
  # CLASS METHODS
  #
  def self.students(year=nil)
    if year.nil?
      all(role: "student")
    else
      all(role: "student", year: year)
    end
  end

  #
  # INSTANCE METHODS
  #
  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def url
    "/students/#{self.netid}"
  end

  def authenticate(attempted_password)
    if self.password == attempted_password
      true
    else
      false
    end
  end

  # Return whether or not user is an advisor.
  def student?
    self.role == "student"
  end

  def admin?
    self.role == "advisor" || self.role == "resident"
  end

  def provisional?
    self.role == "provisional"
  end

  def to_s
    "#{preferred_first || first_name} #{preferred_last || last_name}"
  end
end