class Friendship < ActiveRecord::Base
  belongs_to :user
  #Since friend is not a class, we have to specific what friends is
  belongs_to :friend, :class_name => 'User'
end
