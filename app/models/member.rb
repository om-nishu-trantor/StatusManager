class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :registerable, :recoverable
  
  # Associations
  has_one :role
  has_many :teams_members, class_name: "TeamsMembers"
  has_many :teams, :through => :teams_members, :dependent => :destroy
  
end
