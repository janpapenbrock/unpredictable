class Team

	@@generated_names = []

	attr_accessor :matches, :name

	def initialize name=nil, matches=[]
		@name = name || self.class.generate_name
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

	def self.generate_name
		prefixes = ["FC", "Borussia", "SC", "1. FC", "Sporting"]
		main = ["Townshill", "Entenhausen", "Holzwickede", "Solingen", "Down-under"]

		name = prefixes.sample + " " + main.sample

		return self.generate_name if @@generated_names.include? name
		@@generated_names << name

		name
	end

end