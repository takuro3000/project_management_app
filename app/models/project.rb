class Project < ApplicationRecord
  # プロジェクトは複数のタスクを持ち、プロジェクト削除時に関連タスクも削除される
  has_many :tasks, dependent: :destroy

  # プロジェクト作成・編集時に、タスクの情報も同時に更新できるようにする
  accepts_nested_attributes_for :tasks, allow_destroy: true, reject_if: :all_blank

  # バリデーション
  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 10 }

  # コールバック: 新規作成時にステータスのデフォルト値を設定
  before_create :set_default_status

  # スコープ: ステータスが active なプロジェクトを抽出する
  scope :active, -> { where(status: 'active') }

  private

  def set_default_status
    self.status ||= 'active'
  end
end
