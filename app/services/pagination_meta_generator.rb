module PaginationMetaGenerator
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 10

  def generate_meta(total_pages, total_resources)
    meta = meta_hash(total_pages, total_resources)

    if current_page > 1
      meta[:links][:first] = generate_url(1)
      meta[:links][:prev] = generate_url(current_page - 1)
    end
    meta[:links][:self] = generate_url(current_page)
    if current_page < total_pages
      meta[:links][:next] = generate_url(current_page + 1)
      meta[:links][:last] = generate_url(total_pages)
    end
    meta
  end

  private

  def generate_url(page)
    url = request.base_url + request.path
    [url, url_params(page)].join('?')
  end

  def url_params(page)
    url_params = {}
    url_params[:per_page] = per_page
    url_params[:page] = page

    url_params.to_query
  end

  def meta_hash(total_pages, total_resources)
    {
      links: {},
      meta: {
        current_page: current_page,
        total_pages: total_pages,
        total_resources: total_resources }
    }
  end
end