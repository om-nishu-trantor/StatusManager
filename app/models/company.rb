# == Schema Information
#
# Table name: companies
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  domain_name :string(255)
#  email       :string(255)
#  mobile      :string(255)
#  website     :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Company < ActiveRecord::Base
  
  # Validations
  validates :name, :presence => true, :uniqueness => true

  # Associations
  has_many :teams
  has_one :admin, class_name: "Member"

  attr_accessor :admin_email

  validate :validate_admin_member_email
  after_create :create_admin_of_company

  rails_admin do
    field :name
    field :admin_email do
      label 'Admin Email'
    end
  end

  def validate_admin_member_email
    member = Member.new(:email => self.admin_email, :role => Role.super_admin, :password => SecureRandom.hex(10))
    unless member.valid?
      member.errors.messages.each do |error_field, error_message|
        error_message.each {|message| self.errors.add(error_field, message)}
      end
    end
  end

  def create_admin_of_company
    email = self.admin_email
    member = Member.new(:email => email, :role => Role.super_admin, :password => SecureRandom.hex(10), :company_id => self.id)
    member.skip_confirmation_notification!
    member.save
  end

end
