class BatchProcessorJob < ApplicationJob
  queue_as :default

  def perform(batch_job_id, user_id)
    batch_job = BatchJob.find(batch_job_id)
    user = User.find(user_id)
    Rails.logger.info "#{batch_job.title} starting..."
    errors = []
    batch_job.run(user, errors)
    batch_job.update_attribute(:done, true)
  end
end
