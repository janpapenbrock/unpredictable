require "spec_helper"

describe Match do
	
	before :each do
		@match = Match.new({ home_goals: 2})
	end

	describe "#new" do

		it "can be instantiated with a Hash representing match data" do
			match = Match.new({ home_goals: 2 })
			match.data[:home_goals].should be_true
		end

	end

	it "returns a property in its data as a method result" do
		@match.home_goals.should eql 2
	end

	it "raises a NoMethodError if a non-existing data key is requested" do
		lambda { @match.some_undefined_key }.should raise_exception NoMethodError
	end

end