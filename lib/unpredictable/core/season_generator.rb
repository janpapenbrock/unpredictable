class SeasonGenerator

	@number_of_teams
	
	attr_accessor :teams

	def initialize number_of_teams
		@number_of_teams = number_of_teams
	end

	def teams
		return @teams if @teams
		@teams = (1..@number_of_teams).collect{|n| Team.new }
	end

	def generate_pairings
		return @pairings if @pairings
		@pairings = []
		teams = self.teams

		teams.each do |team|
			available_teams = teams - [ team ]
			available_teams.each do |enemy|
				@pairings << [team, enemy].sort!{|a, b| a.name <=> b.name}
			end
		end
		@pairings.uniq!

		@pairings
	end

	def matches
		return @matches if @matches
		@matches = []
		pairings = generate_pairings

		playdays    = teams.count - 1
		match_count = teams.count / 2

		day = 0

		(1..playdays).each do |playday|
			day += 1
			date = Time.new(2012, 10, day, 15, 30, 00, "+02:00")

			(1..match_count).each do |n|
				match_teams = pairings.sample
				pairings -= match_teams

				(0..1).each do |team_index|
					match = create_match match_teams[team_index], match_teams[team_index-1], date, playday
					@matches << match
					match_teams.each do |team|
						team.add_match match
					end
				end
			end
		end

		@matches
	end

	def create_match home_team, away_team, date, matchday
		home_goals = [0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 4, 5].sample
		away_goals = [0, 0, 0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 4, 5].sample
		
		match = Match.new({
			date: date,
			matchday: matchday,
			home_team: home_team,
			away_team: away_team,
			home_goals: home_goals,
			away_goals: away_goals
		})
		
		match			
	end	

end