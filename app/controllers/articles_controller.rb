class ArticlesController < ApplicationController
  def index
    paginated = Article.recent.page(current_page).per(per_page)
    options = generate_meta(paginated.total_pages, paginated.total_count)
    render json: [paginated, options]
  end

  def show
    render json: Article.find(params[:id])
  end

  private

  def serializer
    ArticleSerializer
  end
end