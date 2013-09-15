require "spec_helper"

describe MatchImporter do

	describe "#import" do

		it "should raise an ArgumentError if called without any arguments" do
			lambda { MatchImporter.import }.should raise_exception ArgumentError
		end

		it "should return a list of matches if given a season year" do
			MatchImporter.import(2012).should be_instance_of Array
		end

	end

end