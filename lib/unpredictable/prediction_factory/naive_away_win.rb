module PredictionFactory
	class NaiveAwayWin

		def predict match
			prediction_data = { home_goals: 1, away_goals: 2 }
			Prediction.new match, prediction_data, self
		end

	end

end