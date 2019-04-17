class BatchJob::TaskDestroyJob < BatchJob

  def title
    "Remove Task Job #{id}"
  end

  def process_hash(current_user, hash, errors)
    task_from_hash(hash)&.destroy ? 1 : 0
  end

  def task_from_hash(hash)
    hash[:id] ? Task.find_by_id(hash[:id]) : nil
  end
end
