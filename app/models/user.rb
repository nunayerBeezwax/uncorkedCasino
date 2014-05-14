class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :login
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :email, presence: true, length: { minimum: 3, maximum: 40 }
  validates :email, uniqueness: true
  validates :username, :uniqueness => { :case_sensitive => false }
  has_one :api_key

  
 #  def login=(login)
 #  	@login = login
 #  end

 #  def login
 #  	@login || self.username || self.email
 #  end

 #  def self.find_first_by_auth_conditions(warden_conditions)
	#   conditions = warden_conditions.dup
	#   if login = conditions.delete(:login)
	#     where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
	#   else
	#     where(conditions).first
	#   end
	# end



  def set_gravatar_url
    hash = Digest::MD5.hexdigest(self.email.downcase.strip)
    update_attributes(gravatar_url: "http://gravatar.com/avatar/#{hash}") 
  end

  #helper methods

  def sign_in
    ApiKey.create(user_id: self.id)
  end

  def sign_out
    ApiKey.find_by(user_id: self.id).destroy
  end

  def signed_in?
    return true if ApiKey.find_by(user_id: self.id) else false
  end



end
