require 'rails_helper'

RSpec.describe GithubApi do
  subject(:github_api) { described_class.new }
  let(:base_uri) { 'api.github.com' }

  describe '#repositories' do
    it 'returns a list of repositories' do
      github_repositories = File.read('spec/fixtures/github_repositories.json')
      repos_url = "#{base_uri}/repositories"

      stub_request(:get, repos_url)
        .to_return(
          status: 200,
          headers: { content_type: 'application/json' },
          body: github_repositories
        )

      response = github_api.repositories

      expect(WebMock).to have_requested(:get, repos_url)
      expect(response.parsed_response).to eq(JSON.parse(github_repositories))
    end
  end

  describe '#search' do
    it 'returns repositories based on query' do
      mojito_repositories = File.read('spec/fixtures/mojito_repositories.json')
      search_repos_url = "#{base_uri}/search/repositories"
      search_query = { q: 'mojito' }

      stub_request(:get, search_repos_url)
        .with(query: search_query )
        .to_return(
          status: 200,
          headers: { content_type: 'application/json' },
          body: mojito_repositories
        )
      
      response = github_api.search_repositories(search_query)

      expect(WebMock).to have_requested(:get, search_repos_url).with(query: search_query)
      expect(response.parsed_response).to eq(JSON.parse(mojito_repositories))
    end    
  end
end