# frozen_string_literal: true
require 'nokogiri'
# app/controllers/home_controller.rb
class JobController < ApplicationController
  def index
    @jobs = Job.all
  end

  def destroy_all
    Job.delete_all
    redirect_to job_index_path, notice: "All jobs have been deleted."
  end
end
