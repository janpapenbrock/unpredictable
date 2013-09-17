module Evaluation

	class Kicktipp

		attr_accessor :prediction, :match

		def initialize prediction, match
			@prediction = prediction
			@match = match
		end

		def evaluate
			return 4 if predicted_result?
			return 3 if predicted_difference?
			return 2 if predicted_tendency?
			0
		end

		def predicted_result?
			[:home_goals, :away_goals].each do |property|
				return false unless @prediction.send(property) == @match.send(property)
			end
			true
		end

		def predicted_difference?
			return false if predicted_result?
			
			return calc_goal_differences.uniq.one?
		end

		def predicted_tendency?
			return false if predicted_result?
			return false if predicted_difference?

			return (calc_goal_differences.reduce(:*) > 0)
		end

		def calc_goal_differences
			[@prediction, @match].collect{|result| result.send(:home_goals) - result.send(:away_goals)}
		end

	end

end