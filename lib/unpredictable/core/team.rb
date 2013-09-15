class Team

	attr_accessor :matches

	def initialize matches=[]
		@matches = matches
	end

	def add_match match
		@matches << match
		@matches.uniq!
		@matches
	end

	def match_before match
		match_before_date match.date
	end

	def match_before_date date
		datetime = date.to_datetime
		matches_before = @matches.select{|match| match.date.to_datetime < datetime}
		matches_before.sort! { |a,b| a.date <=> b.date }
		matches_before.last
	end

end