class BatchJob::AccessTokenUpsertJob < BatchJob

  def title
    "Access Token Update Job #{id}"
  end

  def process_hash(current_user, hash, errors)
    access_token = nil
    if hash[:id]
      access_token = current_user.access_tokens.find(hash[:id])
    else
      access_token = AccessToken.new(user: current_user)
    end
    access_token.assign_attributes(hash.slice(:read_only, :expires_at, :suspended))

    saved = access_token.save
    errors.concat(access_token.errors.full_messages)
    saved ? 1 : 0
  end

  def after(num_updates)
    message = message_for(num_updates)
    Rails.logger.info message
  end
end
