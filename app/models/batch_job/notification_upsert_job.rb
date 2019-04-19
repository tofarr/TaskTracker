class BatchJob::NotificationUpsertJob < BatchJob

  def title
    "Notification Update Job #{id}"
  end

  def process_hash(current_user, hash, errors)
    notification = nil
    if hash[:id]
      notification = Notification.find(hash[:id])
      return 0 unless notification
      notification.assign_attributes(hash.slice(:seen, :include_in_email))
    else
      notification = Notification.new(hash.slice(:task_id, :user_id, :message))
    end

    saved = notification.save
    errors.concat(notification.errors.full_messages)
    saved ? 1 : 0
  end

  def after(num_updates)
    message = message_for(num_updates)
    Rails.logger.info message
  end
end
