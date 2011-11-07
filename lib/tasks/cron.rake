desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  Notice.post
  rails runner 'ActiveRecord::SessionStore.session_class.delete_all(["sessions.updated_at < ?", 3.days.ago])'
end