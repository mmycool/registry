$(document).on 'page:change', ->
  # client side validate all forms
  $('form').each ->
    $(this).validate()

  $('.js-contact-form').on 'restoreDefault', (e) ->
    form = $(e.target)
    form.find('.js-ident-tip').hide()
    switch $('.js-ident-country-code option:selected').val()
      when 'EE'
        $('.js-ident-type').find('option[value=birthday]').prop('disabled', true)
      else
        $('.js-ident-type').find('option[value=birthday]').prop('disabled', false)

  $('.js-ident-country-code').change (e) ->
    form = $('.js-contact-form')
    form.trigger 'restoreDefault'

  $('.js-ident-type').change (e) ->
    form = $('.js-contact-form')
    form.trigger 'restoreDefault'

    switch e.target.value
      # when 'bic'
      # when 'priv'
      when 'birthday'
        form.find('.js-ident-tip').show()

  $('.js-contact-form').trigger('restoreDefault')

  console.log('change')
