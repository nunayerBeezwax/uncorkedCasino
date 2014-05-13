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
  belongs_to :house

  before_create :give_chips

  def login=(login)
  	@login = login
  end

  def login
  	@login || self.username || self.email
  end

  def self.find_first_by_auth_conditions(warden_conditions)
	  conditions = warden_conditions.dup
	  if login = conditions.delete(:login)
	    where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
	  else
	    where(conditions).first
	  end
	end

  def give_chips
  	self.chips = 500
  end
end
