class DefaultFormBuilder < ActionView::Helpers::FormBuilder
  def legal_document_field(method, options = {})
    self.multipart = true
    @template.legal_document_field(@object_name, method, objectify_options(options))
  end

  def money_field(method, options = {})
    @template.money_field(@object_name, method, objectify_options(options))
  end

  def date_field(method, options = {})
    unless options[:value]
      value = @object.send(method)

      if value.present?
        if value.kind_of?(String)
          value = Time.zone.parse(value)
        end

        value = @template.l(value, format: :date)
      end

      options[:value] = value
    end

    @template.date_field(@object_name, method, objectify_options(options))
  end

  def time_field(method, options = {})
    unless options[:value]
      value = @object.send(method)

      if value.present?
        if value.kind_of?(String)
          value = Time.zone.parse(value)
        end

        value = @template.l(value, format: :time)
      end

      options[:value] = value
    end

    @template.time_field(@object_name, method, objectify_options(options))
  end
end
