require "spec_helper"

describe SeasonGenerator do

	before :each do
		@generator = SeasonGenerator.new(4)
	end

	describe "#new" do
		it "throws an ArgumentError if given less than one parameter" do
			lambda { SeasonGenerator.new }.should raise_exception ArgumentError
		end

	end

	describe "#teams" do

		it "returns a list of teams" do
			SeasonGenerator.new(2).teams.should be_instance_of Array
		end

		it "generates as many teams as specified with number of teams" do
			SeasonGenerator.new(16).teams.count.should eql 16
		end

	end

	describe "#generate_pairings" do

		it "returns a list of pairings" do
			SeasonGenerator.new(2).generate_pairings.should be_instance_of Array
		end

		it "generates all pairings as specified with number of teams" do
			SeasonGenerator.new(4).generate_pairings.count.should eql 6
		end

		it "avoids duplicate pairings" do
			pairings = SeasonGenerator.new(4).generate_pairings
			pairings.count.should eql pairings.uniq.count
		end

	end

	describe "#matches" do

		it "returns a list of matches" do
			SeasonGenerator.new(2).matches.should be_instance_of Array
		end

		it "generates all matches as specified with number of teams" do
			SeasonGenerator.new(4).matches.count.should eql 12
		end

		it "generates matches with a matchday number" do
			matches = SeasonGenerator.new(4).matches
			matches.each do |match|
				match.matchday.should > 0
			end
		end

	end

end