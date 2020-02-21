class Api::V1::ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :update, :destroy, :add_to_favorites]
  before_action :owner?, only: [:update, :destroy]

  def index
    render json: Article.all
  end

  def show
    watch_article
    render json: @article
  end

  def add_to_favorites
    @favorite = Favorite.new(user: current_user, article: @article)
    if @favorite.save
      render json: { result: 'Saved to favorites', status: :created }
    else
      render json: { result: @favorite.errors, status: :unprocessable_entity }
    end
  end

  def show_favorites
    render json: current_user.favorite_articles
  end

  def create
    @article = current_user.articles.new(article_params)
    if @article.save
      render json: @article, status: :created
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  def update
    if @article.update(article_params)
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
  end

  def show_authors
    render json: Article.authors
  end

  def show_author_articles
    render json: User.find_by_id(params[:id]).articles
  end

  def show_unread_articles
    render json: current_user.unread_articles
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :text, :preview)
  end

  def owner?
    unless current_user == @article.user
      render json: 'Permission denied'
    end
  end

  def watch_article
    ReadArticle.create(user: current_user, article: @article)
  end
end
