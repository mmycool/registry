module FormHelper
  def legal_document_field(object_name, method, options = {})
    options[:data] = { legal_document: true }
    options[:accept] = legal_document_types unless options[:accept]

    file_field(object_name, method, options)
  end

  def money_field(object_name, method, options = {})
    options[:pattern] = '^[0-9.,]+$' unless options[:pattern]
    options[:maxlength] = 255 unless options[:maxlength]

    text_field(object_name, method, options)
  end

  def date_field(object_name, method, options = {})
    css_class = options[:class].to_s
    css_class << "\s" if css_class.present?
    css_class << 'datepicker date-field'
    options[:class] = css_class

    text_field(object_name, method, options)
  end

  def time_field(object_name, method, options = {})
    options[:maxlength] = 8 unless options[:maxlength]
    options[:pattern] = '^[0-9]{2}:[0-9]{2}:[0-9]{2}$' unless options[:pattern]

    css_class = options[:class].to_s
    css_class << "\s" if css_class.present?
    css_class << 'time-field'
    options[:class] = css_class

    text_field(object_name, method, options)
  end
end
