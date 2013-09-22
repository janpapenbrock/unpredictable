# not runnable example

require_relative "lib/unpredictable/unpredictable.rb"

matches = MatchImporter.new("bl1", 2012).matches

evaluator = Evaluation::Kicktipp
predictors = [ 
	PredictionFactory::PreviousMatch.new, 
	PredictionFactory::NaiveHomeWin.new, 
	PredictionFactory::NaiveAwayWin.new
]

scores = predictors.collect do |predictor|
	predictions = matches.collect do |match|
		predictor.predict match
	end

	predictions.compact!

	scores = predictions.collect do |prediction|
		eval = evaluator.new(prediction, prediction.match)
		score = eval.evaluate 

		score
	end

	total_score = scores.reduce(:+)
	[predictor.class.name, total_score]
end

p scores