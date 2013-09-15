class Prediction

	attr_accessor :match, :prediction_data, :prediction_factory

	def initialize match, prediction_data, prediction_factory
		raise ArgumentError unless prediction_factory.respond_to?(:predict)

		@match = match
		@prediction_data = prediction_data
		@prediction_factory = prediction_factory
	end

	def method_missing name
		return @prediction_data[name] if @prediction_data.key? name
	end

end