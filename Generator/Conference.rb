require 'faker'
#require_relative 'Workshop'

#How many days backward can history go
CONFERENCE_START = 800
#Seed for length
CONFERENCE_DAYS_MAX_DIFF = 12
CONFERENCE_DAYS_BASIC = 4

#Seed for places
PLACES_ROUNDING = -1
BASIC_PLACES = 300
VARIABLE_PLACES = 1000

#Seed for price
PRICE_ROUNDING = -1
BASIC_PRICE = 10
VARIABLE_PRICE = "dependant"
MAX_PRICE = 150

#There are always 3 discount options
DISCOUNT_DAYS = [60, 120, 180, 360]
DISCOUNT_DAYS_MAX_DIFF = 10 
DISCOUNT_AMMOUNTS = [0.05, 0.10, 0.15]
DISCOUNT_AMMOUNTS_MAX_DIFF = 0.05

class Conference
	@@curindex = 1

	attr_accessor :curindex, :id, :name, :startDate, :endDate, :places, :leftPlaces, :price, :days, :discounts

	def initialize()
		@id = @@curindex
		@@curindex +=1
		@name = getSomeCoolName
		@places = (rand()*VARIABLE_PLACES).round(PLACES_ROUNDING)+BASIC_PLACES
		# Now something out of oridinary, what will make things easier
		# by remebering how many places there ale left
		@leftPlaces = @places
		# Price for the conference
		@price = (((Faker::Commerce.price).to_int+BASIC_PRICE)%MAX_PRICE).round(PRICE_ROUNDING)
		makeDates
	end
	
	# Makes some clever days for the conferene along with discounts
	def makeDates
		howManyDaysAgo = (rand()*CONFERENCE_START).round(0)+18
		lengthDays = (rand()*CONFERENCE_DAYS_MAX_DIFF).round() + CONFERENCE_DAYS_BASIC
		@startDate = (Date.today-howManyDaysAgo)
		@endDate = (Date.today-howManyDaysAgo+lengthDays)
		# That's the end of fields you want to print	
		@days = Array.new
		(howManyDaysAgo-lengthDays..howManyDaysAgo).each{|x| @days << (CDay.new((Date.today-x), self))	}
		@days.reverse! # If we want them in correct order
		# Discounts, some weird stuff may happen here, like functional programming
		@discounts = Array.new
		days = DISCOUNT_DAYS.map{|x| x+((rand()-0.5)*DISCOUNT_DAYS_MAX_DIFF).round(0)}
		ammounts = DISCOUNT_AMMOUNTS.map{|x| x+((rand()-0.5)*DISCOUNT_AMMOUNTS_MAX_DIFF).round(2)}
		(0..2).each{|x| @discounts << Discount.new(((@startDate)-days[x].to_i-1), ((@startDate)-days[x+1].to_i), self, ammounts[x])}
	end

	def getSomeCoolName
		names = File.open("NazwyKonferencji").read.split("\n")
		names[rand(names.size)]
	end

	# Checks whether two conferences collide
	def self.Collide first, second
		# Checking whether we have common days
		dayCollision = first.days.map{|x| x.date} & second.days.map{|x| x.date}
		if dayCollision.empty? do 
			return false
		end
		else
			return true
		end
	end


	def to_s
		"\"#{@name}\", \"#{@startDate}\", \"#{@endDate}\", \"#{@places}\", \"#{@price}\""
	end

	def export 
		"exec dbo.DodajKonferencje #{to_s}\n#{(@days.collect{|x| x.export}).join("\n")}\n#{(@discounts.collect{|x| x.export}).join("\n")}"
	end
end

#Days of the conference
class CDay
	@@curindex = 1

	attr_accessor :curindex, :id, :date, :conference

	def initialize(date, conference)
		@id = @@curindex
		@@curindex +=1
		@date = date
		@conference = conference
	end

	def to_s
		"#{(@conference.id)}, \"#{@date.to_s[0..10]}\""
	end

	def export 
		"exec dbo.DodajDzienKonferencji #{to_s}"
	end
end

# For discountss
class Discount
	@@curindex = 1

	attr_accessor :curindex, :id, :date

	def initialize(startDate, endDate, conference, ammount)
		@id = @@curindex
		@@curindex +=1
		@startDate = startDate
		@endDate = endDate
		@ammount = ammount
		@conference = conference
	end

	def to_s
		"#{(@conference.id)}, \"#{@startDate.to_s[0..10]}\", \"#{@endDate.to_s[0..10]}\", \"#{@ammount}\""
	end

	def export 
		"exec dbo.DodajZnizke #{to_s}"
	end

end

