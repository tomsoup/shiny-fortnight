class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friends, through: :friendships
  has_many :friendships

  def full_name
    # if no last or first name for user
    # return Anonymous
    return "#{first_name} #{last_name}".strip if first_name || last_name
    'Anonymous'
  end

  # check if over limit
  def can_add_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_added?(ticker_symbol)
  end

  def under_stock_limit?
    (user_stocks.count < 10)
  end

  def stock_already_added?(ticker_symbol)
    stock = Stock.find_by_ticker(ticker_symbol)
    # if not found, return false
    return false unless stock
    user_stocks.where(stock_id: stock.id).exists?
  end

  def not_friends_with?(friend_id)
    # if less than one, that mean it did not show up at least once, thus they are not friend
    friendships.where(friend_id: friend_id).count < 1
  end

  def except_current_user(users)
    # looking for each element in the user object
    # reject the one where the id of THAT user matches id of the current user
    # self.id means the id of the caller
    users.reject { |user| user.id == id }
  end

  # class level method for search
  def self.search(param)
    # return none if blank
    return User.none if param.blank?

    # ! to save
    # strip to remove initial or tailing space
    param.strip!
    param.downcase!
    # The methods are defined below
    (first_name_matches(param) + last_name_matches(param) + email_matches(param)).uniq
  end

  # matches is what is doing the comparasion
  def self.first_name_matches(param)
    matches('first_name', param)
  end

  def self.last_name_matches(param)
    matches('last_name', param)
  end

  def self.email_matches(param)
    matches('email', param)
  end

  def self.matches(field_name, param)
    # % means wild card
    # % allow blur match e.g john and joh
    where("lower(#{field_name}) like ?", "%#{param}%")
  end
end
