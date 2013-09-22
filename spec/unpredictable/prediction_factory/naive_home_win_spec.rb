require "spec_helper"

describe PredictionFactory::NaiveHomeWin do

	before :each do 
		@factory = PredictionFactory::NaiveHomeWin.new
		@match = double("match")
	end

	describe "#predict" do

		it "throws an ArgumentError if given less than one parameter" do
			lambda { @factory.predict() }.should raise_exception ArgumentError
		end

		it "returns a prediction" do
			@factory.predict(@match).should be_instance_of Prediction
		end

		it "returns a prediction with 2 home_goals and 1 away_goal" do
			prediction = @factory.predict(@match)
			prediction.home_goals.should eql 2
			prediction.away_goals.should eql 1
		end

	end
	
end