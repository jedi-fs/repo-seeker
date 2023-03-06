class GithubApi
  include HTTParty

  base_uri 'api.github.com'

  def repositories
    self.class.get('/repositories')
  end

  def search_repositories(search_query)
    params = {
      q: search_query
    }
    self.class.get('/search/repositories', query: params)
  end
end