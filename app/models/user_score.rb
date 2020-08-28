class UserScore < ApplicationRecord
  belongs_to :user

  def this_month?
    received_at.strftime('%Y%m') == Date.yesterday.strftime('%Y%m')
  end

  def this_week?
    received_at.to_date >= Date.yesterday.beginning_of_week && received_at.to_date <= Date.yesterday.end_of_week
  end

  def yesterday?
    received_at.to_date == Date.yesterday
  end
end
