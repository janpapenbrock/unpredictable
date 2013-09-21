require 'json'
require 'open-uri'

class MatchImporter

	API_ENDPOINT = {
		:host => "openligadb-json.heroku.com",
		:path => "/api/"
	}


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
		@matches = fetch_matches
		@matches
	end

	def fetch_teams
		method = "teams_by_league_saison"
		parse_teams(request method)
	end

	def fetch_matches
		method = "matchdata_by_league_saison"
		parse_matches(request method)
	end

	def parse_teams team_json
		return [] unless team_json.key? "team"
		team_json["team"].collect do |team_data|
			Team.new(team_data["team_name"])
		end
	end

	def parse_matches matches_json
		return [] unless matches_json.key? "matchdata"
		matches_json["matchdata"].collect do |match_data|
			match_attributes = {
				time: Time.parse(match_data["match_date_time"])
			}

			{ "home" => "1", "away" => "2"}.each_pair do |team_type, index|
				team_name = match_data["name_team" + index]
				match_attributes[team_type + "_team"]  = find_team team_name
				match_attributes[team_type + "_goals"] = match_data["points_team" + index]
			end

			match_attributes = Hash[match_attributes.map{|(k,v)| [k.to_sym,v]}]
 			

			Match.new(match_attributes)
		end
	end

	def request method, params={}
		params = request_params params

		query_params = params.map{|k,v| [CGI.escape(k.to_s), "=", CGI.escape(v.to_s)]}.map(&:join).join("&")

		uri = URI::HTTP.build({
			:host => self.class::API_ENDPOINT[:host],
			:path => self.class::API_ENDPOINT[:path] + method,
			:query => query_params
		})

		response = open(uri.to_s).read
		JSON.parse(response)
	end

	def request_params params={}
		{
			league_saison:   @season,
			league_shortcut: @league_code
		}.merge(params)
	end

	def find_team team_name
		teams.select{|team| team.name == team_name}.first
	end


end