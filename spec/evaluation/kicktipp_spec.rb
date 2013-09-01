require_relative "../spec_helper"

describe Evaluation::Kicktipp do

	before :each do
		prediction = { home_goals: 0, away_goals: 0 }
		reality = prediction.clone
		@evaluation = Evaluation::Kicktipp.new prediction, reality
	end

	describe "#new" do
		it "throws an ArgumentError if given less than two parameters" do
			lambda { Evaluation::Kicktipp.new {} }.should raise_exception ArgumentError
		end
	end


	describe "#evaluate" do

		context "game result is draw" do

			it "returns 4 points for exact result" do
				@evaluation.evaluate.should eql 4
			end

			it "returns 3 points if prediction was a remis" do
				@evaluation.prediction = { home_goals: 2, away_goals: 2 }
				@evaluation.evaluate.should eql 3
			end

			it "returns 0 points if prediction was home team win" do
				@evaluation.prediction = { home_goals: 3, away_goals: 2 }
				@evaluation.evaluate.should eql 0
			end

			it "returns 0 points if prediction was away team win" do
				@evaluation.prediction = { home_goals: 1, away_goals: 4 }
				@evaluation.evaluate.should eql 0
			end

		end

		it "returns 4 points for exact result if home team wins" do
			results = { home_goals: 1, away_goals: 0}
			evaluation = Evaluation::Kicktipp.new results, results.clone
			evaluation.evaluate.should eql 4
		end

		it "returns 4 points for exact result if away team wins" do
			results = { home_goals: 1, away_goals: 2}
			evaluation = Evaluation::Kicktipp.new results, results.clone
			evaluation.evaluate.should eql 4
		end

	end

	describe "#calc_goal_differences" do
		it "calculates goal differences for both prediction and reality" do
			prediction = { home_goals: 0, away_goals: 0 }
			reality = 	 { home_goals: 1, away_goals: 2 }
			evaluation = Evaluation::Kicktipp.new prediction, reality
			differences = evaluation.calc_goal_differences
			differences.first.should eql 0
			differences.last.should eql -1
		end
	end

	it "recognizes the exact match of prediction and reality" do
		@evaluation.predicted_result?.should be_true
	end

	it "recognizes that prediction and reality do not match" do
		@evaluation.reality[:home_goals] += 1
		@evaluation.predicted_result?.should be_false
	end

	it "recognizes the correct goal difference of prediction compared to reality" do
		@evaluation.prediction = { home_goals: 1, away_goals: 1 }
		@evaluation.predicted_difference?.should be_true
	end

	it "recognizes an exact match over the same goal difference" do
		@evaluation.predicted_difference?.should be_false
	end

	it "recognizes the correct tendency of prediction compared to reality" do
		prediction = { home_goals: 2, away_goals: 0 }
		reality = { home_goals: 5, away_goals: 0 }
		evaluation = Evaluation::Kicktipp.new prediction, reality
		evaluation.predicted_tendency?.should be_true
	end

	it "recognizes an incorrect tendency when comparing remis to victory" do
		prediction = { home_goals: 0, away_goals: 0 }
		reality = { home_goals: 5, away_goals: 0 }
		evaluation = Evaluation::Kicktipp.new prediction, reality
		evaluation.predicted_tendency?.should be_false
	end

	it "recognizes an incorrect tendency" do
		prediction = { home_goals: 0, away_goals: 2 }
		reality = { home_goals: 5, away_goals: 0 }
		evaluation = Evaluation::Kicktipp.new prediction, reality
		evaluation.predicted_tendency?.should be_false
	end

	it "recognizes an exact match over tendency" do
		@evaluation.predicted_tendency?.should be_false
	end

	it "recognizes goal difference over tendency" do
		@evaluation.prediction = { home_goals: 1, away_goals: 1 }
		@evaluation.predicted_tendency?.should be_false
	end

end