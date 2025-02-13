class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # プロジェクト一覧の表示。関連するタスクも一緒に読み込む。
  def index
    @projects = Project.all.includes(:tasks)
  end

  # プロジェクトの詳細表示
  def show
  end

  # 新規プロジェクト作成フォームの表示
  def new
    @project = Project.new
    # フォームにデフォルトで 3 つのタスク入力欄を用意する
    3.times { @project.tasks.build }
  end

  # プロジェクトと関連タスクの新規作成
  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to @project, notice: "プロジェクトが正常に作成されました。"
    else
      render :new
    end
  end

  # プロジェクト編集フォームの表示
  def edit
    # 既存のタスクがない場合、1 つ分の入力欄を追加する
    @project.tasks.build if @project.tasks.empty?
  end

  # プロジェクトと関連タスクの更新
  def update
    if @project.update(project_params)
      redirect_to @project, notice: "プロジェクトが正常に更新されました。"
    else
      render :edit
    end
  end

  # プロジェクト削除
  def destroy
    @project.destroy
    redirect_to projects_url, notice: "プロジェクトが削除されました。"
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  # strong parameters で、プロジェクトとネストされたタスクのパラメータを許可する
  def project_params
    params.require(:project).permit(
      :name, :description, :status,
      tasks_attributes: [:id, :title, :due_date, :_destroy]
    )
  end
end
