class RepositoriesController < ApplicationController
  def index
    @repositories = github_api.repositories
  end

  def search
    @repositories = repositories_params[:query].present? ? search_repos : nil

    render partial: 'repositories/partials/search_results'
  end

  private

  def repositories_params
    params.permit(:query)
  end

  def github_api
    github_api = GithubApi.new
  end

  def search_repos
    github_api.search_repositories(repositories_params[:query])['items']
  end
end
