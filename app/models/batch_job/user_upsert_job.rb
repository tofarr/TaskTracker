class BatchJob::UserUpsertJob < BatchJob

  def title
    "User Update Job #{id}"
  end

  def process_hash(current_user, hash, errors)
    if(hash[:username].blank?)
      errors << "Entry in batch file missing username!"
      return
    end
    Rails.logger.info "Batch update for User: #{hash[:username]}"
    user = User.find_by_username(hash[:username])
    user = User.new(username: hash[:username]) unless user
    user.assign_attributes(hash.slice(:email, :name))
    if current_user == user
      errors << "Cannot updated admin or suspended for current user!" if hash[:admin] || hash[:suspended]
    else
      user.assign_attributes(hash.slice(:admin, :suspended))
    end
    saved = user.save
    errors.concat(user.errors.full_messages)
    saved ? 1 : 0
  end
end
