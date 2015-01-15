require 'faker'

WORKSHOP_PLACES_ROUNDING = -1
WORKSHOP_BASIC_PLACES = 10
WORKSHOP_VARIABLE_PLACES = 40

WORKSHOP_PRICE_ROUNDING = -1
WORKSHOP_BASIC_PRICE = 20
WORKSHOP_VARIABLE_PRICE = "dependant"
WORKSHOP_MAX_PRICE = 200

class Workshop
	@@curindex = 1

	attr_accessor :curindex, :id, :name, :places, :price, :kDays

	def initialize(conference = 'null')
		@id = @@curindex
		@@curindex +=1
		@name = getSomeCoolName
		@places = (rand()*WORKSHOP_VARIABLE_PLACES).round(WORKSHOP_PLACES_ROUNDING)+WORKSHOP_BASIC_PLACES
		@price = (((Faker::Commerce.price).to_int+WORKSHOP_BASIC_PRICE)%WORKSHOP_MAX_PRICE).round(WORKSHOP_PRICE_ROUNDING)
		@kDays = Array.new
	end

	def getSomeCoolName
		names = File.open("NazwyWarsztatow").read.split("\n")
		names[rand(names.size)]
	end

	def to_s
		"\"#{name}\", #{@places}, \"#{@price}\""
	end
end

class WDays
	@@curindex = 1

	attr_accessor :curindex, :id

	def initialize(workshop, cDay)
		@id = @@curindex
		@@curindex +=1
		@workshop = workshop
		@cDay = cDay
	end

	def to_s
		"\"#{name}\", #{@places}, \"#{@price}\""
	end
end
