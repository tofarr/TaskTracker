module ActivityLogHelper

  def log_create
    if model_obj && model_obj&.persisted?
      ActivityLog.create(model_type: model_type,
        model_id: model_obj&.id,
        user_id: current_user.id,
        username: current_user.username,
        action: 'CREATE',
        new_value: model_obj)
    end
  end

  def log_update
    if model_type && model_obj&.errors&.empty?
      ActivityLog.create(model_type: model_type,
        model_id: model_obj&.id,
        user_id: current_user.id,
        username: current_user.username,
        action: 'UPDATE',
        new_value: model_obj)
    end
  end

  def log_destroy
    if model_type && model_obj&.destroyed?
      ActivityLog.create(model_type: model_type,
        user_id: current_user.id,
        model_id: model_obj&.id,
        username: current_user.username,
        action: 'DESTROY')
    end
  end

end
