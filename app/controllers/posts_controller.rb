class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :baria_user, { only: [:edit, :update, :destroy] }

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      flash[:notice] = "スポットを投稿しました"
      redirect_to posts_path
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def index
    @posts = Post.all
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:notice] = "投稿を更新しました"
      redirect_to post_path(@post.id)
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "スポットを削除しました"
    redirect_to  posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :date, :image, :content)
  end

  def baria_user
    if current_user.nil? || Post.find(params[:id]).user.id.to_i != current_user.id
      flash[:alert] = "権限がありません"
      redirect_to top_path
    end
  end

end
