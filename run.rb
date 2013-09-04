# not runnable example

matches = MatchImporter.importSeason(2012)

predictor = PredictionFactory::PreviousMatch.new
evaluator = Evaluation::Kicktipp.new


predictions = matches.collect do |match|
	predictor.predict match
end

scores = predictions.collect do |prediction|
	evaluator.evaluate prediction
end

total_score = scores.reduce(:+)