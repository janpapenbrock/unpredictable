class Match
	
	attr_accessor :data

	def initialize data={}
		@data = data
	end

	def method_missing name
		return @data[name] if @data.key? name
		raise NoMethodError
	end

end