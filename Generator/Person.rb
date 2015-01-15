require 'faker'
require_relative 'Address'

class Person
	@@curindex = 1
	attr_accessor :curindex, :id, :firstName, :lastName, :phone, :dateOfBirth, :nr, :address, :sex 

	def initialize
		@id = @@curindex
		@@curindex +=1
		@firstName = Faker::Name.first_name
		@lastName = Faker::Name.last_name
		@phone = Faker::Number.number(9)
		@dateOfBirth = Faker::Date.birthday(min_age = 18, max_age = 65)
		@sex = rand().round()
		@nr = studentNr
		@address = Address.new
	end

	def studentNr
		if (rand()<0.1) 			
			Faker::Number.number(6)
		else
			 'null'
		end
	end

	def to_s
		"\"#{@firstName}\", \"#{@lastName}\", \"#{@phone}\", \"#{@dateOfBirth}\", #{@sex}, #{@nr}, #{@address}"
	end
	def export
		"exec dbo.DodajOsobe #{to_s}; \n"
	end
end
