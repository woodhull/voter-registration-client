module VoterRegApi
  class Field < Client
    def self.find(state, language = 'en')
      get(URI.escape("/api/registration/fields/#{state}.json?language=#{language}&key=#{api_key}"))
    end
  end
end