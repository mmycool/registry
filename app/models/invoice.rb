class Invoice < ActiveRecord::Base
  belongs_to :seller, class_name: 'Registrar'
  belongs_to :buyer, class_name: 'Registrar'
  has_one  :account_activity
  has_many :invoice_items

  accepts_nested_attributes_for :invoice_items

  scope :all_columns,                    ->{select("invoices.*")}
  scope :sort_due_date_column,           ->{all_columns.select("CASE WHEN invoices.cancelled_at is not null THEN
                                                                (invoices.cancelled_at + interval '100 year') ELSE
                                                                 invoices.due_date END AS sort_due_date")}
  scope :sort_by_sort_due_date_asc,      ->{sort_due_date_column.order("sort_due_date ASC")}
  scope :sort_by_sort_due_date_desc,     ->{sort_due_date_column.order("sort_due_date DESC")}
  scope :sort_receipt_date_column,       ->{all_columns.includes(:account_activity).references(:account_activity).select(%Q{
                                            CASE WHEN account_activities.created_at is not null THEN account_activities.created_at
                                            WHEN invoices.cancelled_at is not null THEN invoices.cancelled_at + interval '100 year'
                                            ELSE NULL END AS sort_receipt_date })}
  scope :sort_by_sort_receipt_date_asc,  ->{sort_receipt_date_column.order("sort_receipt_date ASC")}
  scope :sort_by_sort_receipt_date_desc, ->{sort_receipt_date_column.order("sort_receipt_date DESC")}

  attr_accessor :billing_email
  validates :billing_email, email_format: { message: :invalid }, allow_blank: true

  validates :due_date, :currency, :seller_name,
            :seller_iban, :buyer_name, :invoice_items, :vat_rate, presence: true

  before_create :set_invoice_number, :check_vat
  before_save   :check_vat
  before_save :calculate_total

  class << self
    def cancel_overdue
      overdue_to_be_cancelled.update_all(cancelled_at: Time.zone.now)
    end

    def unbound
      where('id NOT IN (SELECT invoice_id FROM account_activities WHERE invoice_id IS NOT NULL)')
    end

    private

    def days_to_keep_overdue_invoices_active
      Setting.days_to_keep_overdue_invoices_active.to_i
    end

    def overdue_to_be_cancelled
      to_be_cancelled_from = days_to_keep_overdue_invoices_active.days.ago
      not_cancelled.unbound.where('due_date < ?', to_be_cancelled_from)
    end

    def not_cancelled
      where('cancelled_at IS NULL')
    end
  end

  def date
    created_at
  end

  def set_invoice_number
    last_no = Invoice.order(number: :desc).where('number IS NOT NULL').limit(1).pluck(:number).first

    if last_no && last_no >= Setting.invoice_number_min.to_i
      self.number = last_no + 1
    else
      self.number = Setting.invoice_number_min.to_i
    end

    return if number <= Setting.invoice_number_max.to_i

    errors.add(:base, I18n.t('failed_to_generate_invoice_invoice_number_limit_reached'))
    logger.error('INVOICE NUMBER LIMIT REACHED, COULD NOT GENERATE INVOICE')
    false
  end

  def check_vat
    if buyer.country_code != 'EE' && buyer.vat_no.present?
      self.vat_rate = 0
    end
  end

  def binded?
    account_activity.present?
  end

  def receipt_date
    account_activity.try(:created_at)
  end

  def to_s
    I18n.t('invoice_no', no: number)
  end

  def seller_address
    [seller_street, seller_city, seller_state, seller_zip].reject(&:blank?).compact.join(', ')
  end

  def buyer_address
    [buyer_street, buyer_city, buyer_state, buyer_zip].reject(&:blank?).compact.join(', ')
  end

  def seller_country
    Country.new(seller_country_code)
  end

  def buyer_country
    Country.new(buyer_country_code)
  end

  # order is used for banklink description
  def order
    "Order nr. #{number}"
  end
  
  def pdf(html)
    kit = PDFKit.new(html)
    kit.to_pdf
  end

  def pdf_name
    "invoice-#{number}.pdf"
  end

  def cancel
    if binded?
      errors.add(:base, I18n.t('cannot_cancel_paid_invoice'))
      return false
    end

    if cancelled?
      errors.add(:base, I18n.t('cannot_cancel_cancelled_invoice'))
      return false
    end

    self.cancelled_at = Time.zone.now
    save
  end

  def cancelled?
    cancelled_at.present?
  end

  def forward(html)
    return false unless valid?
    return false unless billing_email.present?

    InvoiceMailer.invoice_email(id, html, billing_email).deliver
    true
  end

  def items
    invoice_items
  end

  def subtotal
    (items.map(&:amount).sum).round(2)
  end

  def vat_amount
    subtotal * vat_rate
  end

  def paid?
    return false if account_activity.nil?
    return false if account_activity.bank_transaction.nil?
    return false if account_activity.bank_transaction.sum.nil?

    account_activity.bank_transaction.sum == self.total
  end

  private

  def calculate_total
    self.total = subtotal + vat_amount
  end
end
