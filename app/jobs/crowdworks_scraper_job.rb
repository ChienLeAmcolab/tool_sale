class CrowdworksScraperJob < ApplicationJob
  queue_as :default

  def perform(username, password, apply_prompt)
    service = CrowdworksScraperService.new(username, password)
    service.perform(apply_prompt)
  end
end
