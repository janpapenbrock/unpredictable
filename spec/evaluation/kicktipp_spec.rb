require_relative "../spec_helper"

describe Evaluation::Kicktipp do

	before :each do
		@prediction = double("prediction")
		@reality = double("reality")
		[@prediction, @reality].each do |result|
			allow(result).to receive(:home_goals).and_return(0)
			allow(result).to receive(:away_goals).and_return(0)
		end
		@evaluation = Evaluation::Kicktipp.new @prediction, @reality
	end

	describe "#new" do
		it "throws an ArgumentError if given less than two parameters" do
			lambda { Evaluation::Kicktipp.new {} }.should raise_exception ArgumentError
		end
	end


	describe "#evaluate" do

		context "when game result is draw" do

			it "returns 4 points for exact result" do
				@evaluation.evaluate.should eql 4
			end

			it "returns 3 points if prediction was a different draw" do
				allow(@prediction).to receive(:home_goals).and_return(2)
				allow(@prediction).to receive(:away_goals).and_return(2)
				@evaluation.evaluate.should eql 3
			end

			it "returns 0 points if prediction was a home team victory" do
				allow(@prediction).to receive(:home_goals).and_return(3)
				allow(@prediction).to receive(:away_goals).and_return(2)
				@evaluation.evaluate.should eql 0
			end

			it "returns 0 points if prediction was an away team victory" do
				allow(@prediction).to receive(:home_goals).and_return(1)
				allow(@prediction).to receive(:away_goals).and_return(4)
				@evaluation.evaluate.should eql 0
			end

		end

		context "when game result is home team victory" do

			it "returns 4 points for exact result" do
				[@prediction, @reality].each do |result|
					allow(result).to receive(:home_goals).and_return(1)
					allow(result).to receive(:away_goals).and_return(0)
				end

				@evaluation.evaluate.should eql 4
			end

			it "returns 3 points for correct goal difference of prediction" do
				allow(@prediction).to receive(:home_goals).and_return(4)
				allow(@prediction).to receive(:away_goals).and_return(3)
				allow(@reality).to receive(:home_goals).and_return(1)
				allow(@reality).to receive(:away_goals).and_return(0)

				@evaluation.evaluate.should eql 3
			end

			it "returns 2 points for correctly predicting the winning team" do
				allow(@prediction).to receive(:home_goals).and_return(5)
				allow(@prediction).to receive(:away_goals).and_return(0)
				allow(@reality).to receive(:home_goals).and_return(1)
				allow(@reality).to receive(:away_goals).and_return(0)

				@evaluation.evaluate.should eql 2
			end

			it "returns 0 points if prediction was a draw" do
				allow(@prediction).to receive(:home_goals).and_return(2)
				allow(@prediction).to receive(:away_goals).and_return(2)
				allow(@reality).to receive(:home_goals).and_return(1)
				allow(@reality).to receive(:away_goals).and_return(0)

				@evaluation.evaluate.should eql 0
			end

			it "returns 0 points if prediction was an away team victory" do
				allow(@prediction).to receive(:home_goals).and_return(0)
				allow(@prediction).to receive(:away_goals).and_return(2)
				allow(@reality).to receive(:home_goals).and_return(1)
				allow(@reality).to receive(:away_goals).and_return(0)

				@evaluation.evaluate.should eql 0
			end

		end

		context "when game result is away team victory" do

			it "returns 4 points for exact result" do
				[@prediction, @reality].each do |result|
					allow(result).to receive(:home_goals).and_return(0)
					allow(result).to receive(:away_goals).and_return(1)
				end
				
				@evaluation.evaluate.should eql 4
			end

			it "returns 3 points for correct goal difference of prediction" do
				allow(@prediction).to receive(:home_goals).and_return(3)
				allow(@prediction).to receive(:away_goals).and_return(4)
				allow(@reality).to receive(:home_goals).and_return(0)
				allow(@reality).to receive(:away_goals).and_return(1)
				
				@evaluation.evaluate.should eql 3
			end

			it "returns 2 points for correctly predicting the winning team" do
				allow(@prediction).to receive(:home_goals).and_return(0)
				allow(@prediction).to receive(:away_goals).and_return(5)
				allow(@reality).to receive(:home_goals).and_return(0)
				allow(@reality).to receive(:away_goals).and_return(1)

				@evaluation.evaluate.should eql 2
			end

			it "returns 0 points if prediction was a draw" do
				allow(@prediction).to receive(:home_goals).and_return(2)
				allow(@prediction).to receive(:away_goals).and_return(2)
				allow(@reality).to receive(:home_goals).and_return(0)
				allow(@reality).to receive(:away_goals).and_return(1)

				@evaluation.evaluate.should eql 0
			end

			it "returns 0 points if prediction was a home team victory" do
				allow(@prediction).to receive(:home_goals).and_return(2)
				allow(@prediction).to receive(:away_goals).and_return(0)
				allow(@reality).to receive(:home_goals).and_return(0)
				allow(@reality).to receive(:away_goals).and_return(1)

				@evaluation.evaluate.should eql 0
			end

		end

	end

	describe "#calc_goal_differences" do
		it "calculates goal differences for both prediction and reality" do
			allow(@prediction).to receive(:home_goals).and_return(0)
			allow(@prediction).to receive(:away_goals).and_return(0)
			allow(@reality).to receive(:home_goals).and_return(1)
			allow(@reality).to receive(:away_goals).and_return(2)

			differences = @evaluation.calc_goal_differences
			differences.first.should eql 0
			differences.last.should eql -1
		end
	end

	it "recognizes the exact match of prediction and reality" do
		@evaluation.predicted_result?.should be_true
	end

	it "recognizes that prediction and reality do not match" do
		allow(@reality).to receive(:home_goals).and_return(1)
		@evaluation.predicted_result?.should be_false
	end

	it "recognizes the correct goal difference of prediction compared to reality" do
		allow(@prediction).to receive(:home_goals).and_return(1)
		allow(@prediction).to receive(:away_goals).and_return(1)
		@evaluation.predicted_difference?.should be_true
	end

	it "recognizes an exact match over the same goal difference" do
		@evaluation.predicted_difference?.should be_false
	end

	it "recognizes the correct tendency of prediction compared to reality" do
		allow(@prediction).to receive(:home_goals).and_return(2)
		allow(@prediction).to receive(:away_goals).and_return(0)
		allow(@reality).to receive(:home_goals).and_return(5)
		allow(@reality).to receive(:away_goals).and_return(0)

		@evaluation.predicted_tendency?.should be_true
	end

	it "recognizes an incorrect tendency when comparing remis to victory" do
		allow(@prediction).to receive(:home_goals).and_return(0)
		allow(@prediction).to receive(:away_goals).and_return(0)
		allow(@reality).to receive(:home_goals).and_return(5)
		allow(@reality).to receive(:away_goals).and_return(0)

		@evaluation.predicted_tendency?.should be_false
	end

	it "recognizes an incorrect tendency" do
		allow(@prediction).to receive(:home_goals).and_return(0)
		allow(@prediction).to receive(:away_goals).and_return(2)
		allow(@reality).to receive(:home_goals).and_return(5)
		allow(@reality).to receive(:away_goals).and_return(0)

		@evaluation.predicted_tendency?.should be_false
	end

	it "recognizes an exact match over tendency" do
		@evaluation.predicted_tendency?.should be_false
	end

	it "recognizes goal difference over tendency" do
		allow(@prediction).to receive(:home_goals).and_return(1)
		allow(@prediction).to receive(:away_goals).and_return(1)
		@evaluation.predicted_tendency?.should be_false
	end

end