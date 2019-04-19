class BatchJob < ApplicationRecord

  belongs_to :user
  has_one_attached :data

  validates :user, presence: true
  validate :validate_data

  def title
    "#{self.class.name}:#{id}"
  end

  #Hook
  def before(current_user)
    raise ApplicationController::NotAuthorized unless current_user.admin?
  end

  def after(num_updates)
    message = message_for(num_updates)
    Rails.logger.info message
    Notification.create(message: message, user: user, created_by_user: user)
  end

  def message_for(num_updates)
    if errors.empty?
      "#{title}: Finished with #{num_updates} updates."
    else
      "#{title}: Finished with #{num_updates} updates and the following errors:\n\t#{errors.join('\n\t')}"
    end
  end

  def run(current_user, errors)
    before(current_user)
    case data.content_type
    when "text/csv"
      after(run_csv(current_user, errors))
    when "application/json"
      after(run_json(current_user, errors))
    end
  end

  def run_csv(current_user, errors)
    count = 0
    begin
      CSV.parse(data.download, :headers => true, :header_converters => :symbol).each do |row|
        count = count + process_hash(current_user, row.to_hash, errors)
      end
    rescue StandardError => error
      errors << error
    end
    count
  end

  def run_json(current_user, errors)
    count = 0
    begin
      JSON.parse(data.download, :symbolize_names => true).each do |hash|
        count = count + process_hash(current_user, hash, errors)
      end
    rescue StandardError => error
      errors << error
    end
    count
  end

  def process_hash(hash, errors)
    raise "NotYetImplemented!"
  end

  def validate_data
    if data.attachment
      errors.add(:data, "Invalid File Type: #{data.content_type}") unless ['text/csv', 'application/json'].include?(data.content_type)
    else
      errors.add(:data, "File must not be blank!")
    end
  end

  def update_array(model, hash, attr)
    set_attr = "#{attr.to_s}=".to_sym
    model.send(set_attr, array_attr(hash, attr)) if hash[attr]

    add_attr = "add_#{attr.to_s}".to_sym
    model.send(set_attr, (user.tag_ids + array_attr(hash, add_attr)).uniq) if hash[add_attr]

    remove_attr = "remove_#{attr.to_s}".to_sym
    model.send(set_attr, (user.tag_ids - array_attr(hash, remove_attr))) if hash[remove_attr]
  end

  def array_attr(hash, attr)
    ret = hash[attr]
    return [] if ret.blank?
    ret = ret.split('|') if ret.is_a?(String)
    ret.map(&:to_i)
  end
end
