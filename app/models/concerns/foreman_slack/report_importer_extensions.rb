module ForemanSlack
  module ReportImporterExtensions
    extend ActiveSupport::Concern

    private

    module Overrides
      def notify_on_report_error_with_slack(mail_error_state)
        if Setting[:notify_slack_puppet_error] && report.error?
          slack = ForemanSlack::SlackNotify.new
          slack.notify(_('%s is in error state. Please check logs') % name)
        end
        notify_on_report_error_without_slack(mail_error_state)
      end
    end

    included do
      prepend Overrides
    end

  end
end
