xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Notifications"
    xml.description "A list of notifications for #{@current_user.title}"
    xml.link root_url

    @notifications.each do |notification|
      xml.item do
        xml.title notification.title
        xml.description notification.message
        xml.pubDate notification.created_at.to_s(:rfc822)
        xml.link notification_url(notification)
        xml.guid notification_url(notification)
      end
    end
  end
end
