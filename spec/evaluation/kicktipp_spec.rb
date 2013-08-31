require_relative "../spec_helper"

describe Evaluation::Kicktipp do

	before :each do
		prediction = reality = { home_goals: 0, away_goals: 0 }
		@evaluation = Evaluation::Kicktipp.new prediction, reality
	end

	describe "#new" do
		it "throws an ArgumentError if given less than two parameters" do
			lambda { Evaluation::Kicktipp.new {} }.should raise_exception ArgumentError
		end
	end


	describe "#evaluate" do

		it "returns 4 points for exact result on remis" do
			@evaluation.evaluate.should eql 4
		end

		it "returns 4 points for exact result if home team wins" do
			results = { home_goals: 1, away_goals: 0}
			evaluation = Evaluation::Kicktipp.new results, results
			evaluation.evaluate.should eql 4
		end

		it "returns 4 points for exact result if away team wins" do
			results = { home_goals: 1, away_goals: 2}
			evaluation = Evaluation::Kicktipp.new results, results
			evaluation.evaluate.should eql 4
		end

	end

end