class ScoreTitleFetcher
  def call(score)
    response = connection.get("/dev/score_title?score=#{score}")
    json_body = JSON.parse(response.body)

    { status: response.status }.tap do |hash|
      hash[:title] = json_body['title'] if hash[:status] == 200
    end
  end

  private

  def connection
    @connection ||= Faraday.new(Rails.configuration.api_endpoint)
  end
end
