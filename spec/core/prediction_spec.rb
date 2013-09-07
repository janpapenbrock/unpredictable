require_relative "../spec_helper"

describe Prediction do
	
	before :each do
		@prediction_factory = double("prediction_factory", :predict => true)
		@match = double("match")
		@prediction = Prediction.new @match,{}, @prediction_factory
	end

	describe "#new" do

		it "throws an ArgumentError if given less than three parameters" do
			lambda { Prediction.new([], []) }.should raise_exception ArgumentError
		end		

		it "throws an ArgumentError if third parameter is not a prediction factory" do
			lambda { Prediction.new(@match, {}, []) }.should raise_exception ArgumentError
		end

		it "accepts a Match, a PredictionFactory and prediction data parameters" do
			prediction = Prediction.new(@match, {}, @prediction_factory)
			prediction.should be_instance_of Prediction
			prediction.match.should eql @match
			prediction.prediction_factory.should eql @prediction_factory
			prediction.prediction_data.should == {}
		end

	end

end