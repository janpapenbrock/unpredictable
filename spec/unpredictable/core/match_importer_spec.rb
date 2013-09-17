require "spec_helper"

describe MatchImporter do

	before :each do
		@importer = MatchImporter.new("bl1", 2012)
	end

	describe "#new" do

		it "should raise an ArgumentError if called with less than two arguments" do
			lambda { MatchImporter.new("any")}.should raise_exception ArgumentError
		end

		it "should accept a league code and a season" do
			importer = MatchImporter.new("bl1", 2012)
			importer.league_code.should eql "bl1"
			importer.season.should eql 2012
		end

	end

	describe "#teams" do
		it "should return a list of teams" do
			@importer.teams.should be_instance_of Array
		end

		it "should return 18 teams" do
			@importer.teams.count.should eql 18
		end
	end

	describe "#matches" do

		it "should return a list of matches" do
			@importer.matches.should be_instance_of Array
		end

		it "should return 34 * 9 matches" do
			@importer.matches.count.should eql (34 * 9)
		end

	end

	describe "#request_params" do
		it "should always contain league code and season" do
			params = @importer.request_params
			params.keys.should include :league_shortcut
			params.keys.should include :league_saison
		end

		it "should merge in additional params" do
			params = @importer.request_params({ foo: "bar" })
			params.keys.should include :foo
			params[:foo].should eql "bar"
		end
	end

	describe "#parse_teams" do
		it "should accept a json string and return team instances" do
			json = JSON.parse('{"team":[{"team_id":"7","team_name":"Borussia Dortmund","team_icon_url":"http://www.openligadb.de/images/teamicons/Borussia_Dortmund.gif"},{"team_id":"131","team_name":"VfL Wolfsburg","team_icon_url":"http://www.openligadb.de/images/teamicons/VfL_Wolfsburg.gif"}]}')
			teams = @importer.parse_teams json
			teams.count.should eql 2
			teams.first.name.should eql "Borussia Dortmund"
		end
	end

end