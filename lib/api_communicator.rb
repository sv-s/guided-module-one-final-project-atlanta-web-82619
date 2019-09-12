require 'rest-client'
require 'json'
require 'pry'

class APICommunicator
    api_index_url = 'https://projects.propublica.org/nonprofits/api/v2/search.json?'
    
    def default_results
        JSON.parse(RestClient.get(api_index_url))
    end

    
end