require 'rails_helper'

RSpec.describe "GithubSearches", type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:github_repositories) { File.read('spec/fixtures/github_repositories.json') }
  let(:mojito_repositories) { File.read('spec/fixtures/mojito_repositories.json') }
  let(:base_uri) { "api.github.com" }
  let(:repos_url) { "#{base_uri}/repositories" }

  before do
    stub_request(:get, repos_url)
      .to_return(
        status: 200,
        body: github_repositories,
        headers: { content_type: 'application/json' }
      )
  end

  it 'displays all the repositories by default' do
    visit repositories_path

    repo_names = JSON.parse(github_repositories).pluck('name')

    expect(page).to have_css('h1', text: 'Repo Seeker')
    expect(page).to have_css('ul li', count: repo_names.size)
    repo_names.each do |name|
      expect(page).to have_css('ul li', text: name)
    end
  end

  it 'displays search results' do
    search_repos_url = "#{base_uri}/search/repositories"
    search_query = { q: 'mojito' }

    stub_request(:get, search_repos_url)
      .with(query: search_query)
      .to_return(
        status: 200,
        body: mojito_repositories,
        headers: { content_type: 'application/json' }
      )

    visit repositories_path

    fill_in :query, with: 'mojito'
    click_on 'Search'

    repo_names = JSON.parse(mojito_repositories)['items'].pluck('name')

    expect(page).to have_css('ul li', count: repo_names.size)
    repo_names.each do |name|
      expect(page).to have_css('ul li', text: name)
    end
  end
end
