xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Tasks"
    xml.description @current_user ? "A list of tasks available to #{@current_user.title}" : "A list of tasks"
    xml.link root_url

    @tasks.each do |task|
      xml.item do
        xml.title task.title
        xml.description task.description
        xml.pubDate task.created_at.to_s(:rfc822)
        xml.link task_url(task)
        xml.guid task_url(task)
      end
    end
  end
end
