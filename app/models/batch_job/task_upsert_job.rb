class BatchJob::TaskUpsertJob < BatchJob

  def title
    "Task Update Job #{id}"
  end

  def process_hash(current_user, hash, errors)
    task = nil
    if hash[:id]
      task = Task.find(hash[:id])
    else
      task = Task.new
    end

    task.assign_attributes(hash.slice(:title, :description, :parent_id, :assigned_user_id,
      :created_by_user_id, :status_id, :priority, :due_date, :estimate, :viewable,
      :editable, :commentable, :public_viewable))

    update_array(task, hash, :tag_ids)

    saved = task.save
    errors.concat(task.errors.full_messages)
    saved ? 1 : 0
  end
end
