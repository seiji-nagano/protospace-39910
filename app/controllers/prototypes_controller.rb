class PrototypesController < ApplicationController
  before_action :move_to_index, except: [:index, :show]
  before_action :set_prototype, only: [:edit, :show, :update]

  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params) # 新しいPrototypeオブジェクトを作成
    if @prototype.save
      redirect_to '/'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    if user_signed_in? && current_user == @prototype.user
      # ログイン済みかつプロトタイプの所有者の場合は編集を許可
      render :edit
    else
      redirect_to root_path, alert: '他のユーザーのプロトタイプを編集する権限がありません'
    end
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end

  private
  def prototype_params
    params.require(:prototype).permit(:title, :image, :catch_copy, :concept).merge(user_id: current_user.id)
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end


  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end

end
