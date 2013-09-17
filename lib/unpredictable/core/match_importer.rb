require 'json'

class MatchImporter

	API_BASE = "http://openligadb-json.heroku.com/api/"

	attr_reader :league_code, :season

	def initialize league_code, season
		@league_code = league_code
		@season = season
	end

	def teams
		return @teams if @teams
		@teams = fetch_teams
		@teams
	end

	def matches
		return @matches if @matches
		@matches = []
		@matches
	end

	def fetch_teams
		method = "teams_by_league_saison"
		team_data = request method
		parse_teams team_data
	end

	def parse_teams team_json
		return [] unless team_json.key? "team"
		team_json["team"].collect do |team_data|
			Team.new(team_data["team_name"])
		end
	end

	def request method, params={}
		JSON.parse("{}")
	end

	def request_params params={}
		{
			league_saison:   @season,
			league_shortcut: @league_code
		}.merge(params)
	end


end