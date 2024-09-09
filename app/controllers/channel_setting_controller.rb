# frozen_string_literal: true
require 'nokogiri'
# app/controllers/home_controller.rb
class ChannelSettingController < ApplicationController
  def index
    @last_info = FormHistory.last
    @system_setting = SystemSetting.first
    @progress = Rails.cache.read('scraper_progress') || 0
  end

  def create
    parameters = params[:parameters]
    prompt = params[:apply_prompt]
    email = params[:email]
    password = params[:password]
    parameters_string = parameters.map do |param|
      "#{param[:name]}:#{param[:value]}"
    end.join(", ")
    FormHistory.create!(email: email, apply_prompt: prompt)
    combined_prompt = parameters_string + prompt
    send_content = CrowdworksScraperJob.perform_later(email, password, combined_prompt)
  end

  def toggle_apply_render
    @system_setting = SystemSetting.first
    if @system_setting.update(status: params[:system_setting][:status])
      redirect_to channel_setting_index_path, notice: 'Setting updated successfully!'
    else
      render :index, alert: 'Failed to update setting.'
    end
  end

  def all_job
    @jobs = Job.all
  end
  def show_progress
    if File.exist?('progress.txt')
      progress_percentage = File.read('progress.txt').to_f
    else
      progress_percentage = 0
    end
    render json: { progress: progress_percentage }
  end

  def reset_progress
    if File.exist?('progress.txt')
      File.write('progress.txt', '0')
    end
    head :ok
  end

end
