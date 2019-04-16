class BatchJob::UserDestroyJob < BatchJob

  def title
    "Remove User Job #{id}"
  end

  def process_hash(current_user, hash, errors)
    user = user_from_hash(hash)
    if user.nil?
      return 0
    elsif user == current_user
      errors << 'User cannot delete current user!'
      return 0
    else
      return user.destroy ? 1 : 0
    end
  end

  def user_from_hash(hash)
    if hash[:username]
      User.find_by_username(hash[:username])
    if hash[:id]
      User.find_by_id(hash[:id])
    elsif hash[:email]
      User.find_by_email(hash[:email])
    else
      nil
    end
  end
end
