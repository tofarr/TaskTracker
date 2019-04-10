module Migration

  def self.import
    #Minimal migration of open tasks for now - will do this properly later
    user = User.first
    status = TaskStatus.where(default_apply: true).first
    JSON.parse(File.read("db/migration.json")).each do |task_json|
      Task.create(title: task_json["title"],
        description: task_json["description"],
        priority: task_json["priority"],
        created_user: user,
        assigned_user: user,
        status: status)
    end
  end


  def self.export
    #Minimal migration of open tasks for now...
    status_ids = TaskStatus.where(requires_action: true).select(:id).map(&:id)

    File.open("db/migration.json", 'w') do |file|
      file.write('[')
      Task.where(status_id: status_ids).each_with_index do |task, index|
        file.write(',') if(index > 0)
        file.write(task.as_json.slice("title", "description", "priority").to_json)
      end
      file.write(']')
    end

  end

  class Migration

  end
end

=begin
    export_settings
    export_model(:task_statuses) # should include next status ids (Require 2 step import)
    export_model(:task_tags)
    export_model(:user_tags)

    export_model(:task_tag_mutex)
    export_model(:user_tag_mutex)

    export_model(:users) # Should include tag ids

    export_model(:tasks) # Include parent id (Require 2 step import), tag_ids, assigned_user_id, created_user_id, status_id

    export_model(:task_links)

    export_model(:comments)

    export_model(:attachments)

    export_model(:task_searches)

    export_model(:scrum_boards)

    export_model(:activity_log) #Optional!

    export_model(:notifications) #Optional!
=end
