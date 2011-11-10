task :cron => :environment do
  def task_with_logger_and_notify(*args, &block)
    new_block = proc {
      begin
        Rails.logger.info "[pid:#{Process.pid}][time:#{Time.now.to_s(:db)}][cron START] #{args.inspect}"

        yield if block_given?

        Rails.logger.info "[pid:#{Process.pid}][time:#{Time.now.to_s(:db)}][cron END] #{args.inspect}"
      rescue => e
        Rails.logger.error "[pid:#{Process.pid}][time:#{Time.now.to_s(:db)}][cron ERROR] #{e}"
        HoptoadNotifier.notify(e)
        raise e
      ensure
        Rails.logger.flush
      end
    }
    task(*args, &new_block)
  end

  desc "Notice.post and delete old sessions. "
  task_with_logger_and_notify :post_notice => :environment do
    Notice.post
    ActiveRecord::SessionStore.session_class.delete_all(["sessions.updated_at < ?", 3.days.ago])
  end
end
