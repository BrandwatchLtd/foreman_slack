module ForemanSlack
  module DiscoveredHostExtensions
    extend ActiveSupport::Concern

    included do
      alias_method_chain :send_built_notification, :slack
    end

    private

    def send_discovered_notification_with_slack
      if Setting[:send_built_notification]
        slack = ForemanSlack::SlackNotify.new
        slack.notify(_('%s has been discovered!') % name)
      end
      send_discovered_notification_without_slack
    end
  end
end
