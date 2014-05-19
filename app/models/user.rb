class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessor :login
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :email, presence: true, length: { minimum: 3, maximum: 50 }
  validates :email, uniqueness: true
  validates :username, :uniqueness => { :case_sensitive => false }
  has_one :api_key
  has_one :seat
  has_one :table, through: :seat

  def sit(table, seatnumber=nil)
    if seatnumber == nil
      table.first_vacant.update(user_id: self.id)
    elsif table.seats[seatnumber].occupied?
      false
    else
      table.vacancies[seatnumber].update(user_id: self.id)
    end
  end

  def seated?
    !self.seat.nil?
  end

  def leave_table
    self.update(seat: nil)
  end

  def first_open(game)
    matching_tables =[]
    Table.all.each do |t|
      if t.game_name == game
        matching_tables << t
      end
    end
    matching_tables.reject{ |t| t.full_table?  }
    self.sit(matching_tables.first)
  end

  def state
    state = {}
    !self.seat.table.number.nil?  ? state["table #"] = self.seat.table.number : state["table #"] = ''
    !self.seat.table.game.name.nil?  ? state["Game name"] = self.seat.table.game.name : state["Game name"] = ''
    !self.seat.cards.nil?  ? state["Hand"] = self.seat.cards.name : state["Hand"] = ''
    !self.seat.table.house_cards.nil?  ? state["House cards"] = self.seat.table.house_cards.name : state["House cards"] = ''
    state

  end


  def set_gravatar_url
    hash = Digest::MD5.hexdigest(self.email.downcase.strip)
    update_attributes(gravatar_url: "http://gravatar.com/avatar/#{hash}") 
  end

  def sign_in
    ApiKey.create(user_id: self.id)
  end

  def sign_out
    ApiKey.find_by(user_id: self.id).destroy
  end

  def signed_in?
   !ApiKey.find_by(user_id: self.id).nil? 
  end
end
