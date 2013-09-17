# not runnable example

require_relative "lib/unpredictable/unpredictable.rb"

matches = SeasonGenerator.new(18).matches

predictor = PredictionFactory::PreviousMatch.new
evaluator = Evaluation::Kicktipp

predictions = matches.collect do |match|
	predictor.predict match
end

predictions.compact!

scores = predictions.collect do |prediction|
	puts prediction
	eval = evaluator.new(prediction, prediction.match)
	score = eval.evaluate 

	puts score
	score
end

total_score = scores.reduce(:+)
p total_score