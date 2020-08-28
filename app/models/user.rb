class User < ApplicationRecord
  has_many :user_scores
  has_one :rank

  def total_score
    @total_score ||= user_scores.sum(&:score)
  end

  def score_hold?
    user_scores.present?
  end

  def monthly_total_score
    monthly_scores.sum(&:score)
  end

  def monthly_score_hold?
    monthly_scores.present?
  end

  def weekly_total_score
    weekly_scores.sum(&:score)
  end

  def weekly_score_hold?
    weekly_scores.present?
  end

  def daily_total_score
    daily_scores.sum(&:score)
  end

  def daily_score_hold?
    daily_scores.present?
  end

  private

  def monthly_scores
    @monthly_scores ||= user_scores.select(&:this_month?)
  end

  def weekly_scores
    @weekly_scores ||= user_scores.select(&:this_week?)
  end

  def daily_scores
    @daily_scores ||= user_scores.select(&:yesterday?)
  end
end
