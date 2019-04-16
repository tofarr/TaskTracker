class BatchProcessorJob < ApplicationJob
  queue_as :default

  def perform(batch_job_id, user_id)
    batch_job = BatchJob.find(batch_job_id)
    user = User.find(user_id)
    Rails.logger.info "#{batch_job.title} starting..."
    errors = []
    num_updates = batch_job.run(user, errors)
    message = if errors.empty?
            "#{batch_job.title}: Finished with #{num_updates} updates."
          else
            "#{batch_job.title}: Finished with #{num_updates} updates and the following errors:\n\t#{errors.join('\n\t')}"
          end
    Rails.logger.info message
    Notification.create(message: message, user: user, created_by_user: user)
    batch_job.update_attribute(:done, true)
  end
end
