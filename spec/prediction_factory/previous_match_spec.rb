require_relative "../spec_helper"

describe PredictionFactory::PreviousMatch do

	before :each do 
		@factory = PredictionFactory::PreviousMatch.new
		@match = Match.new
		@team1_matches = [ Match.new, @match ]
		@team2_matches = [ Match.new, @match ]
	end

	describe "#predict" do

		it "throws an ArgumentError if given less than one parameter" do
			lambda { @factory.predict() }.should raise_exception ArgumentError
		end

		it "throws an ArgumentError if first parameter is not a match instance" do
			lambda { @factory.predict( [] ) }.should raise_exception ArgumentError
		end

		context "given a valid match with previous matches for both teams" do

			it "returns a prediction" do
				@factory.predict.should be_instance_of Prediction
			end

		end

		context "given a match without previous matches for both teams" do

			it "returns nil" do
				@factory.predict.should be_nil
			end

		end


	end
	
end