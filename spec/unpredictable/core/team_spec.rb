require "spec_helper"

describe Team do
	
	before :each do
		@match1 = double("match", date: Time.new(2008,1,1, 13,30,0, "+02:00"))
		@match2 = double("match", date: Time.new(2008,1,15, 13,30,0, "+02:00"))
		@match3 = double("match", date: Time.new(2008,1,29, 13,30,0, "+02:00"))
		@team = Team.new( "Borussia Dortmund", [@match1, @match2] )
	end

	describe "#new" do

		it "should accept a name as first parameter" do
			team = Team.new ( "Manchester United" )
			team.name.should eql "Manchester United"
		end

		it "should generate a random name if not given a name" do
			team = Team.new
			team.name.should_not be_nil
		end

		it "should generate a random name if given nil as the name" do
			team = Team.new nil
			team.name.should_not be_nil
		end

		it "should accept a list of matches" do
			team = Team.new( nil, [ @match1 ])
			team.matches.count.should eql 1
			team.matches.should include @match1
		end

	end

	it "should have a name" do
		@team.name.should eql "Borussia Dortmund"
	end

	it "should keep a list of matches played" do
		@team.matches.should include @match1
		@team.matches.count.should eql 2
	end

	describe "#add_match" do

		it "should raise an ArgumentError if given no arguments" do
			lambda { @team.add_match }.should raise_exception ArgumentError
		end

		it "should return the new list of matches" do
			match = double("match")
			@team.add_match(match).should be_instance_of Array
		end

		it "should accept a match to add to the list of matches" do
			match = double("match")
			@team.add_match(match).should include match
		end

		it "should add a match once only" do
			match = double("match")
			count = @team.add_match(match).count
			@team.add_match(match).count.should eql count
		end

	end

	describe "#match_before" do

		it "should return the match played before a specific match" do
			@team.match_before(@match3).should == @match2
		end

		it "should return nil if there was no match played before a specific match" do
			@team.match_before(@match1).should be_nil
		end

		it "should return nil if the team has not played any matches" do
			team = Team.new
			team.match_before(@match1).should be_nil
		end

		it "should return the same result as calling match_before_date" do
			before_date_result = @team.match_before_date(@match3.date)
			@team.match_before(@match3).should == before_date_result
		end

	end

	describe "#match_before_date" do

		it "should return the match played before a specific date" do
			@team.match_before_date(@match3.date).should == @match2
		end

		it "should return nil if no match was played before a specific date" do
			@team.match_before_date(@match1.date).should be_nil
		end

		it "should return nil if the team has not played any matches" do
			team = Team.new
			team.match_before_date(@match1.date).should be_nil
		end

		it "should return the same result as calling match_before" do
			before_result = @team.match_before(@match3)
			@team.match_before_date(@match3.date).should == before_result
		end

	end

	describe "#generate_name" do
		it "should generate a random team name with two parts" do
			name = @team.class.generate_name
			name.split(" ").count.should > 1
		end

		it "should not return the same name twice" do
			name = @team.class.generate_name
			@team.class.generate_name.should_not eql name
		end
	end

end