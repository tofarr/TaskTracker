module BulkEditHelper


  def prepare_job(job, &block)
    if(params[:data_content_type] == 'params')
      block.call(job)
    elsif(params[:data].is_a?(String))
      attach_string_as_file_to_job(job)
    elsif(params[:data].is_a?(Hash))
      attach_json_as_file_to_job(job)
    else
      job.data.attach(params[:data])
    end
    job
  end

  def attach_string_as_file_to_job(job)
    content_type = params[:data_content_type]
    extension = MIME::Types[content_type].first.extensions.first
    job.data.attach(io: StringIO.new(params[:data]), content_type: content_type, filename: "upload.#{extension}")
  end

  def attach_string_as_file_to_job(job)
    content_type = params[:data_content_type]
    job.data.attach(io: StringIO.new(params[:data].to_json), content_type: "application/json", filename: "upload.json")
  end
end
