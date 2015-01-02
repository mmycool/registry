class Domain < ActiveRecord::Base
  # TODO: whois requests ip whitelist for full info for own domains and partial info for other domains
  # TODO: most inputs should be trimmed before validatation, probably some global logic?
  paginates_per 10 # just for showoff

  belongs_to :registrar
  belongs_to :owner_contact, class_name: 'Contact'

  has_many :domain_contacts, dependent: :delete_all
  accepts_nested_attributes_for :domain_contacts, allow_destroy: true

  has_many :tech_contacts,
           -> { where(domain_contacts: { contact_type: DomainContact::TECH }) },
           through: :domain_contacts, source: :contact

  has_many :admin_contacts,
           -> { where(domain_contacts: { contact_type: DomainContact::ADMIN }) },
           through: :domain_contacts, source: :contact

  has_many :nameservers, dependent: :delete_all, after_add: :track_nameserver_add

  accepts_nested_attributes_for :nameservers, allow_destroy: true,
                                              reject_if: proc { |attrs| attrs[:hostname].blank? }

  has_many :domain_statuses, dependent: :delete_all
  accepts_nested_attributes_for :domain_statuses, allow_destroy: true,
                                                  reject_if: proc { |attrs| attrs[:value].blank? }

  has_many :domain_transfers, dependent: :delete_all

  has_many :dnskeys, dependent: :delete_all

  has_many :keyrelays

  accepts_nested_attributes_for :dnskeys, allow_destroy: true,
                                          reject_if: proc { |attrs| attrs[:public_key].blank? }

  has_many :legal_documents, as: :documentable

  delegate :code, to: :owner_contact, prefix: true
  delegate :email, to: :owner_contact, prefix: true
  delegate :ident, to: :owner_contact, prefix: true
  delegate :phone, to: :owner_contact, prefix: true
  delegate :name, to: :registrar, prefix: true

  before_create :generate_auth_info
  before_create :set_validity_dates
  before_create :attach_default_contacts
  after_save :manage_automatic_statuses

  validates :name_dirty, domain_name: true, uniqueness: true
  validates :period, numericality: { only_integer: true }
  validates :owner_contact, :registrar, presence: true

  validate :validate_period

  validates :nameservers, object_count: {
    min: -> { Setting.ns_min_count },
    max: -> { Setting.ns_max_count }
  }

  validates :dnskeys, object_count: {
    min: -> { Setting.dnskeys_min_count },
    max: -> { Setting.dnskeys_max_count }
  }

  validates :admin_domain_contacts, object_count: {
    association: 'admin_contacts',
    min: -> { Setting.admin_contacts_min_count },
    max: -> { Setting.admin_contacts_max_count }
  }

  validates :tech_domain_contacts, object_count: {
    association: 'tech_contacts',
    min: -> { Setting.tech_contacts_min_count },
    max: -> { Setting.tech_contacts_max_count }
  }

  validates :nameservers, uniqueness_multi: {
    attribute: 'hostname'
  }

  validates :tech_domain_contacts, uniqueness_multi: {
    association: 'domain_contacts',
    attribute: 'contact_code_cache'
  }

  validates :admin_domain_contacts, uniqueness_multi: {
    association: 'domain_contacts',
    attribute: 'contact_code_cache'
  }

  validates :domain_statuses, uniqueness_multi: {
    attribute: 'value'
  }

  validates :dnskeys, uniqueness_multi: {
    attribute: 'public_key'
  }

  validate :validate_nameserver_ips

  attr_accessor :owner_contact_typeahead, :update_me

  # archiving
  # if proc works only on changes on domain sadly
  has_paper_trail class_name: 'DomainVersion', meta: { snapshot: :create_snapshot }, if: proc(&:new_version)

  def tech_domain_contacts
    domain_contacts.select { |x| x.contact_type == DomainContact::TECH }
  end

  def admin_domain_contacts
    domain_contacts.select { |x| x.contact_type == DomainContact::ADMIN }
  end

  def new_version
    return false if versions.try(:last).try(:snapshot) == create_snapshot
    true
  end

  def create_version
    return true unless PaperTrail.enabled?
    return true unless valid?
    touch_with_version if new_version
  end

  def track_nameserver_add(_nameserver)
    return true if versions.count == 0
    return true unless valid? && new_version

    touch_with_version
  end

  def create_snapshot
    oc = owner_contact.snapshot if owner_contact.is_a?(Contact)
    {
      owner_contact: oc,
      tech_contacts: tech_contacts.map(&:snapshot),
      admin_contacts: admin_contacts.map(&:snapshot),
      nameservers: nameservers.map(&:snapshot),
      domain: make_snapshot
    }.to_yaml
  end

  def make_snapshot
    {
      name: name,
      status: status,
      period: period,
      period_unit: period_unit,
      registrar_id: registrar.try(:id),
      valid_to: valid_to,
      valid_from: valid_from
    }
  end

  def name=(value)
    value.strip!
    value.downcase!
    self[:name] = SimpleIDN.to_unicode(value)
    self[:name_puny] = SimpleIDN.to_ascii(value)
    self[:name_dirty] = value
  end

  def owner_contact_typeahead
    @owner_contact_typeahead || owner_contact.try(:name) || nil
  end

  def pending_transfer
    domain_transfers.find_by(status: DomainTransfer::PENDING)
  end

  def can_be_deleted?
    (domain_statuses.pluck(:value) & %W(
      #{DomainStatus::SERVER_DELETE_PROHIBITED}
    )).empty?
  end

  ### VALIDATIONS ###

  def validate_nameserver_ips
    nameservers.each do |ns|
      next unless ns.hostname.end_with?(name)
      next if ns.ipv4.present?
      errors.add(:nameservers, :invalid) if errors[:nameservers].blank?
      ns.errors.add(:ipv4, :blank)
    end
  end

  def validate_period
    return unless period.present?
    if period_unit == 'd'
      valid_values = %w(365 366 710 712 1065 1068)
    elsif period_unit == 'm'
      valid_values = %w(12 24 36)
    else
      valid_values = %w(1 2 3)
    end

    errors.add(:period, :out_of_range) unless valid_values.include?(period.to_s)
  end

  # used for highlighting form tabs
  def parent_valid?
    assoc_errors = errors.keys.select { |x| x.match(/\./) }
    (errors.keys - assoc_errors).empty?
  end

  def statuses_tab_valid?
    !errors.keys.any? { |x| x.match(/domain_statuses/) }
  end

  ## SHARED

  def name_in_wire_format
    res = ''
    parts = name.split('.')
    parts.each do |x|
      res += sprintf('%02X', x.length) # length of label in hex
      res += x.each_byte.map { |b| sprintf('%02X', b) }.join # label
    end

    res += '00'

    res
  end

  def to_s
    name
  end

  # rubocop:disable Lint/Loop
  def generate_auth_info
    begin
      self.auth_info = SecureRandom.hex
    end while self.class.exists?(auth_info: auth_info)
  end
  # rubocop:enable Lint/Loop

  def attach_default_contacts
    if tech_domain_contacts.count.zero?
      attach_contact(DomainContact::TECH, owner_contact)
    end

    return unless admin_domain_contacts.count.zero? && owner_contact.citizen?
    attach_contact(DomainContact::ADMIN, owner_contact)
  end

  def attach_contact(type, contact)
    domain_contacts.build(
      contact: contact, contact_type: DomainContact::TECH, contact_code_cache: contact.code
    ) if type.to_sym == :tech

    domain_contacts.build(
      contact: contact, contact_type: DomainContact::ADMIN, contact_code_cache: contact.code
    ) if type.to_sym == :admin
  end

  def set_validity_dates
    self.registered_at = Time.zone.now
    self.valid_from = Date.today
    self.valid_to = valid_from + self.class.convert_period_to_time(period, period_unit)
  end

  def manage_automatic_statuses
    if domain_statuses.empty? && valid?
      domain_statuses.create(value: DomainStatus::OK)
    elsif domain_statuses.length > 1 || !valid?
      domain_statuses.find_by(value: DomainStatus::OK).try(:destroy)
    end
  end

  class << self
    def convert_period_to_time(period, unit)
      return period.to_i.days if unit == 'd'
      return period.to_i.months if unit == 'm'
      return period.to_i.years if unit == 'y'
    end
  end
end
