require "spec_helper"

describe PredictionFactory::NaiveAwayWin do

	before :each do 
		@factory = PredictionFactory::NaiveAwayWin.new
		@match = double("match")
	end

	describe "#predict" do

		it "throws an ArgumentError if given less than one parameter" do
			lambda { @factory.predict() }.should raise_exception ArgumentError
		end

		it "returns a prediction" do
			@factory.predict(@match).should be_instance_of Prediction
		end

		it "returns a prediction with 1 home_goals and 2 away_goal" do
			prediction = @factory.predict(@match)
			prediction.home_goals.should eql 1
			prediction.away_goals.should eql 2
		end

	end
	
end