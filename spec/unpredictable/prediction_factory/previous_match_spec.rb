require "spec_helper"

describe PredictionFactory::PreviousMatch do

	before :each do 
		@factory = PredictionFactory::PreviousMatch.new
		@team1 = double("team")
		@team2 = double("team")
		@team3 = double("team")
		@match  = double("match", home_team: @team1, away_team: @team2)
		@match2 = @match.clone
		@match3 = double("match", home_team: @team1, away_team: @team3)

		[@match, @match2].each do |match|
			allow(match).to receive(:goals_by).and_return 1
		end
		allow(@match3).to receive(:goals_by).and_return 2

		{ @team1 => @match2, @team2 => @match3, @team3 => nil}.each_pair do |team, match|
			allow(team).to receive(:match_before).and_return(match)
		end
	end

	describe "#predict" do

		it "throws an ArgumentError if given less than one parameter" do
			lambda { @factory.predict() }.should raise_exception ArgumentError
		end

		context "given a valid match with previous matches for both teams" do
			it "returns a prediction" do
				@factory.predict(@match).should be_instance_of Prediction
			end
		end

		context "given a match without previous matches for both teams" do
			it "returns nil" do
				@factory.predict(@match3).should be_nil
			end
		end

	end

	describe "#calculate_prediction" do
		it "calculates the correct prediction" do
			prediction = @factory.calculate_prediction @match
			prediction.prediction_data[:home_goals].should eql 1
			prediction.prediction_data[:away_goals].should eql 2
		end
	end

	it "can predict a complete match" do
		@factory.can_predict_match?(@match).should be_true
	end

	it "cannot predict an incomplete match" do
		@factory.can_predict_match?(@match3).should be_false
	end
	
end