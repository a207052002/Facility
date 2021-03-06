# cronotab.rb — Crono configuration file
#
# Here you can specify periodic jobs and schedule.
# You can use ActiveJob's jobs from `app/jobs/`
# You can use any class. The only requirement is that
# class should have a method `perform` without arguments.
#
# class TestJob
#   def perform
#     puts 'Test!'
#   end
# end
#
# Crono.perform(TestJob).every 2.days, at: '15:30'
#

class MailTask
  def perform
    facilities = Facility.where(verify: true)
    if facilities.present?
      facilities.each do |f|
        rents = f.rents.where(notified: false)
        if rents.present?
          NotifyMailer.notify_rent(f, rents.count).deliver_later!
          rents.update(notified: true)
        end
      end
    end
  end
end

Crono.perform(MailTask).every 3600.seconds
