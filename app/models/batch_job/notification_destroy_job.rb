class BatchJob::NotificationDestroyJob < BatchJob

  def title
    "Remove Notification Job #{id}"
  end

  def process_hash(current_user, hash, errors)
    notification_from_hash(hash)&.destroy ? 1 : 0
  end

  def notification_from_hash(hash)
    hash[:id] ? Notification.find_by_id(hash[:id]) : nil
  end

  def after(num_updates)
    message = message_for(num_updates)
    Rails.logger.info message
  end
end
