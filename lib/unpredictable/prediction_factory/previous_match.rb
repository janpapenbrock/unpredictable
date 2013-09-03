module PredictionFactory
	class PreviousMatch

		def predict match

			raise ArgumentError unless match.is_a? Match

		end

	end
end