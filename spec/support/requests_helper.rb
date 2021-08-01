require "rails_helper"

module RequestsHelper
	include Rack::Test::Methods

	def response_json
		JSON.parse(last_response.body)
	end

	def parse_json(value)
		JSON.parse(value.to_json)
	end
end

RSpec.configure do |config|
	config.include RequestsHelper, type: :request
end