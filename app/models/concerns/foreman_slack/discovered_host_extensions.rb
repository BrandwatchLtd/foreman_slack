module ForemanSlack
  module DiscoveredHostExtensions
    extend ActiveSupport::Concern

    included do
      alias_method_chain :import_facts, :slack
    end

    private

    def import_facts_with_slack(facts)
      if Setting[:notify_slack_discovered_host]
        location = 'Unknown location'
        if SETTINGS[:locations_enabled]
          location = facts["foreman_location"] || 'Unknown location'
          switch_chassis = facts["lldp_neighbor_sysname_eth0"] || 'Unknown'
        end
        slack = ForemanSlack::SlackNotify.new
        slack.notify(_('New host: %s discovered in switch %s in %s') % [name,switch_chassis,location])
        Rails.logger.info "ForemanSlack notification sent for #{name} attached to #{switch_chassis} in #{location}"
      end
      import_facts_without_slack(facts)
    end
  end
end
