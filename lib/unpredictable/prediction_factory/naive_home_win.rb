module PredictionFactory
	class NaiveHomeWin

		def predict match
			prediction_data = { home_goals: 2, away_goals: 1 }
			Prediction.new match, prediction_data, self
		end

	end

end