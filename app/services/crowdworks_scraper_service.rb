require 'nokogiri'
require 'watir'
require 'active_support/cache'

class CrowdworksScraperService
  def initialize(username, password)
    @username = username
    @password = password
  end

  def perform(apply_prompt)
    browser = Watir::Browser.new
    File.write('progress.txt', 5.0)
    begin
      sleep 0.5
      browser.goto 'https://crowdworks.jp/login?back=1&ref=public_header'
      browser.text_field(name: 'username').set @username
      sleep 0.84
      browser.text_field(name: 'password').set @password
      sleep 0.6
      browser.button(type: 'submit').click
      sleep 0.72
      if browser.url.include?('error_message')
        File.write('progress.txt', 100.0)
        return false
      end

      browser.goto 'https://crowdworks.jp/watchlist/job_offers?ref=login_header'
      page_content = browser.html

      doc = Nokogiri::HTML(page_content)
      jobs_infos = []

      doc.css('li[data-job_offer_id]').each do |li|
        job_id = li['data-job_offer_id']
        title_element = li.at_css('h3.item_title a')

        if job_id && title_element
          title = title_element.text.strip
          link = title_element['href']
          target = title_element['target']
          rel = title_element['rel']
          data_item_title_link = title_element['data-item-title-link']

          jobs_infos << {
            job_id: job_id,
            title: title,
            link: link,
            target: target,
            rel: rel,
            data_item_title_link: data_item_title_link
          }
        end
      end
      starting_percentage = 10.0
      File.write('progress.txt', starting_percentage)

      total_jobs = jobs_infos.size
      completed_jobs = 0

      jobs_infos.each do |job|
        unless SystemSetting.first.status
          break
        end
        job_link_public = "https://crowdworks.jp/public/jobs/#{job[:job_id]}"
        browser.goto(job_link_public)
        job_content = browser.element(css: 'td.confirm_outside_link').text

        gpt_prompt = apply_prompt + job_content
        gpt_reply = GptChatService.new(gpt_prompt).call

        completed_jobs += 0.5
        progress_percentage = (completed_jobs.to_f / total_jobs * 90).round(2) + starting_percentage
        File.write('progress.txt', progress_percentage)

        sleep 0.2
        job_link_apply = "https://crowdworks.jp/proposals/new?job_offer_id=#{job[:job_id]}"
        sleep 0.2
        browser.goto(job_link_apply)
        browser.radio(id: 'without_condition_true').wait_until(&:present?).set
        sleep 0.2
        browser.textarea(id: 'proposal_conditions_attributes_0_message_attributes_body').wait_until(&:present?).set(gpt_reply)

        job_record = Job.find_or_initialize_by(job_page_id: job[:job_id])

        job_record.assign_attributes(
          gpt_prompt: gpt_prompt,
          gpt_reply: gpt_reply,
          status: 'unknown'
        )
        job_record.save

        completed_jobs += 0.5

        progress_percentage = (completed_jobs.to_f / total_jobs * 90).round(2) + starting_percentage
        File.write('progress.txt', progress_percentage)
      end
    ensure
      browser.close
    end
  end
end
