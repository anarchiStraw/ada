task :cron => :environment do
    Notice.post
    ActiveRecord::SessionStore.session_class.delete_all(["sessions.updated_at < ?", 3.days.ago])
end
