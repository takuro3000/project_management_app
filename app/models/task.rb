class Task < ApplicationRecord
  belongs_to :project

  # バリデーション
  validates :title, presence: true
  validates :due_date, presence: true

  # 独自バリデーション: 期限が今日以前にならないようにする
  validate :due_date_cannot_be_in_the_past

  private

  def due_date_cannot_be_in_the_past
    if due_date.present? && due_date < Date.today
      errors.add(:due_date, "は本日以降の日付を選択してください")
    end
  end
end
