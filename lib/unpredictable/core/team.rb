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

	def match_before_date time
		matches_before = @matches.select{|match| match.date < time}
		matches_before.sort! { |a,b| a.date <=> b.date }
		matches_before.last
	end

	def self.generate_name
		prefixes = ["Real", "BV", "Spvgg", "Sportfreunde", "FC", "Borussia", "SC", "1. FC", "Sporting", "AS", "Lazio", "DJK"]
		main = ["Townshill", "Entenhausen", "Holzwickede", "Solingen", "Down-under", "Iraklion", "Moskau", "Paris", "Rom", "Vorwald"]

		prefixes.shuffle.first + " " + main.shuffle.first
	end

end