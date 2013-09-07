module PredictionFactory
	class PreviousMatch

		def predict match
			return unless can_predict_match? match
			calculate_prediction match
		end

		def can_predict_match? match
			[match.home_team, match.away_team].each do |team|
				previous_match = team.match_before(match)
				return false unless previous_match
			end
			true
		end

		def calculate_prediction match
			prediction_data = {}
			{ match.home_team => :home_goals, match.away_team => :away_goals}.each_pair do |team, prediction_key|
				previous_match = team.match_before(match)
				goals = previous_match.goals_by(team)
				prediction_data[prediction_key] = goals
			end

			Prediction.new match, prediction_data, self
		end

	end
end