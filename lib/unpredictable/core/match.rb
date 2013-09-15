class Match
	
	attr_accessor :data

	def initialize data={}
		@data = data
	end

	def goals_by team
		{:home_team => :home_goals, :away_team => :away_goals}.each_pair do |match_team, goals|
			return @data[goals] if @data[match_team] == team
		end
		nil
	end

	def method_missing name
		return @data[name] if @data.key? name
		raise NoMethodError
	end

end