class DomainContact < ActiveRecord::Base
  include EppErrors
  belongs_to :contact
  belongs_to :domain

  EPP_ATTR_MAP = {
    hostname: 'hostObj'
  }

  def epp_code_map
    {
      '2302' => [
        [:contact, :taken, {value: {obj: 'contact', val: contact.code}}]
      ]
    }
  end

  TECH = 'tech'
  ADMIN = 'admin'
  TYPES = [TECH, ADMIN]

  # TODO: Fix EPP problems
  validates :contact, uniqueness: { scope: [:domain_id, :contact_type] }

  scope :admin, -> { where(contact_type: ADMIN) }
  scope :tech, -> { where(contact_type: TECH) }

  def admin?
    contact_type == ADMIN
  end

  def tech?
    contact_type == TECH
  end
end
