require 'rest-client'
require 'json'
require 'pry'

class APICommunicator
    def default_results
        JSON.parse(RestClient.get('https://projects.propublica.org/nonprofits/api/v2/search.json'))
    end
end