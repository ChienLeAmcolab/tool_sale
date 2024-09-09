class Job < ApplicationRecord
  enum status: { not_sent: 0, sent: 1, unknown: 2 }

  validates :job_page_id, presence: true, uniqueness: true
end
