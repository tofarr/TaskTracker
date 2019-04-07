module LocaleHelper

  def set_locale
    I18n.locale = @current_user.locale and return if @current_user

    # try to use the accept header if no user defined
    locale = extract_locale_from_accept_language_header
    I18n.locale = (locale && I18n.available_locales.include?(locale.to_sym)) ? locale : I18n.default_locale
  end

  #Set the timezone to be used to parse dates from that in the current user
  def set_time_zone
    begin
      Time.zone = current_user.try(:timezone) || "UTC"
    rescue
      logger.warn "Invalid timezone #{current_user.try(:timezone)} for user #{current_user.id}"
      Time.zone = "UTC"
    end
  end

  def extract_locale_from_accept_language_header
    (request.env['HTTP_ACCEPT_LANGUAGE'] || '').scan(/^[a-z]{2}/).first
  end
end
