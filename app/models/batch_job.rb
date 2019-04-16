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

  def run(current_user, errors)
    before(current_user)
    case data.content_type
    when "text/csv"
      run_csv(current_user, errors)
    when "application/json"
      run_json(current_user, errors)
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
end
