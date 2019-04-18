require 'data_uri'
require 'mime-types'

class ApplicationController < ActionController::Base

  include ApplicationHelper
  include LoginHelper
  include LocaleHelper
  include ActivityLogHelper
  include BulkEditHelper

  #From LoginHelper
  before_action :do_login
  before_action :require_login
  before_action :set_locale
  before_action :disallow_edits_with_read_only_token, only: [:new,:create,:edit,:update,:destroy]

  #From ApplicationHelper
  helper_method :text_color

  #From ApplicationHelper
  helper_method :bool_with_nil_opts

  #From ActivityLogHelper
  after_action :log_create, only: :create
  after_action :log_update, only: :update
  after_action :log_destroy, only: :destroy


  def model_type
    return nil
  end

  def model_obj
    self.instance_variable_get("@#{model_type.underscore}")
  end

  def attach_file(attr_sym)
    if params[:delete] && params[:delete][attr_sym]
      attr = model_obj.send(attr_sym)
      attr.purge if attr.attached?
      return
    end
    f = params[model_type.underscore.to_sym][attr_sym]
    if f
      if f.class.name == 'String' && f.starts_with?('data:') # String was sent - manually convert to file
        uri = URI::Data.new(f)
        extension = MIME::Types[uri.content_type].first.extensions.first
        model_obj.send(attr_sym).attach(io: StringIO.new(uri.data), filename: "upload.#{extension}")
      else
        model_obj.send(attr_sym).attach(f)
      end
    end
  end

  #We support token based login - token is added to all urls
  def default_url_options(options = {})
    options[:token] = @access_token.token if @access_token
    options
  end

  private

  def page(query)
    if params[:per] && params[:per] > 50
      raise LoginHelper::NotAuthorized unless current_user.admin?
    end
    query.page(params[:page]).per(params[:per] || 10)
  end

end
