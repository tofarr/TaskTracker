class BatchJob::AccessTokenDestroyJob < BatchJob

  def title
    "Remove Access Token Job #{id}"
  end

  def process_hash(current_user, hash, errors)
    access_token_from_hash(current_user, hash)&.destroy ? 1 : 0
  end

  def access_token_from_hash(current_user, hash)
    hash[:id] ? current_user.access_tokens.find_by_id(hash[:id]) : nil
  end

  def after(num_updates)
    message = message_for(num_updates)
    Rails.logger.info message
  end
end
