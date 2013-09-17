require "spec_helper"

describe Match do
	
	before :each do
		@home_team = double("team")
		@away_team = double("team")
		@match = Match.new({ home_goals: 2, away_goals: 1, home_team: @home_team, away_team: @away_team })
	end

	describe "#new" do

		it "can be instantiated with a Hash representing match data" do
			match = Match.new({ home_goals: 2 })
			match.data[:home_goals].should be_true
		end

	end

	describe "#goals_by" do

		it "should return the goals for a team" do
			@match.goals_by(@away_team).should eql 1
		end

		it "should return nil if the team did not play the match" do
			team = double("team")
			@match.goals_by(team).should be_nil
		end

	end

	it "returns a property in its data as a method result" do
		@match.home_goals.should eql 2
	end

	it "raises a NoMethodError if a non-existing data key is requested" do
		lambda { @match.some_undefined_key }.should raise_exception NoMethodError
	end

end