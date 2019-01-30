class RegistrantUser < User
  attr_accessor :idc_data

  devise :trackable, :timeoutable, :id_card_authenticatable

  def ability
    @ability ||= Ability.new(self)
  end
  delegate :can?, :cannot?, to: :ability

  def ident
    registrant_ident.to_s.split('-').last
  end

  def country_code
    registrant_ident.to_s.split('-').first
  end

  # In Rails 5, can be replaced with a much simpler `or` query method and the raw SQL parts can be
  # removed.
  # https://guides.rubyonrails.org/active_record_querying.html#or-conditions
  def domains
    domains_where_is_contact = begin
      Domain.joins(:domain_contacts)
            .where(domain_contacts: { contact_id: contacts })
    end

    domains_where_is_registrant = Domain.where(registrant_id: contacts)

    Domain.from(
      "(#{domains_where_is_registrant.to_sql} UNION " \
      "#{domains_where_is_contact.to_sql}) AS domains"
    )
  end

  def contacts
    Contact.where(ident_type: 'priv', ident: ident, ident_country_code: country_code)
  end

  def administered_domains
    domains_where_is_administrative_contact = begin
      Domain.joins(:domain_contacts)
            .where(domain_contacts: { contact_id: contacts, type: [AdminDomainContact] })
    end

    domains_where_is_registrant = Domain.where(registrant_id: contacts)

    Domain.from(
      "(#{domains_where_is_registrant.to_sql} UNION " \
      "#{domains_where_is_administrative_contact.to_sql}) AS domains"
    )
  end

  def to_s
    username
  end

  def first_name
    username.split.first
  end

  def last_name
    username.split.second
  end

  class << self
    def find_or_create_by_api_data(user_data = {})
      return false unless user_data[:ident]
      return false unless user_data[:first_name]
      return false unless user_data[:last_name]

      user_data.each_value { |v| v.upcase! if v.is_a?(String) }
      user_data[:country_code] ||= 'EE'

      find_or_create_by_user_data(user_data)
    end

    def find_or_create_by_mid_data(response)
      user_data = { first_name: response.user_givenname, last_name: response.user_surname,
                    ident: response.user_id_code, country_code: response.user_country }

      find_or_create_by_user_data(user_data)
    end

    def find_by_id_card(id_card)
      registrant_ident = "#{id_card.country_code}-#{id_card.personal_code}"
      username = [id_card.first_name, id_card.last_name].join("\s")

      user = find_or_initialize_by(registrant_ident: registrant_ident)
      user.username = username
      user.save!
      user
    end

    private

    def find_or_create_by_user_data(user_data = {})
      return unless user_data[:first_name]
      return unless user_data[:last_name]
      return unless user_data[:ident]
      return unless user_data[:country_code]

      user = find_or_create_by(registrant_ident: "#{user_data[:country_code]}-#{user_data[:ident]}")
      user.username = "#{user_data[:first_name]} #{user_data[:last_name]}"
      user.save

      user
    end
  end
end
