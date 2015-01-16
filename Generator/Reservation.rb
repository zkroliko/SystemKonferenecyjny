#Reservation for conference
require_relative 'Workshop'

RESERVATION_BASE_QUOTA = 0.05
RESERVATION_VARY_QUOTA = 0.05

STUDENT_PROPORTION = 0.1

class CReservation

	@@curindex = 1

	attr_accessor :curindex, :id, :date

	def initialize(client, cday)
		@id = @@curindex
		@@curindex +=1
		@client = client		
		@cday = cday
		@conference = @cday.conference
		# Now let's make a decision on number of places on the reservation
		# The ammount of places is randomized based on constants
		# , the @leftPlaces field of conference is updated
		if (client.instance_of?(CompanyClient) and @conference.leftPlaces > 0)
			# We are comapny aparently
			places = (@conference.places*(RESERVATION_VARY_QUOTA*rand()+RESERVATION_BASE_QUOTA))%(@conference.leftPlaces)
			@conference.leftPlaces -= places.to_i
			puts @conference.leftPlaces
			if (@conference.leftPlaces <=0)
				return false
			else
			@students = (places*STUDENT_PROPORTION).to_i
			# Lets check whether there is place left for students
			@normal = (places*(1-STUDENT_PROPORTION)).to_i
			puts "baba"
		end else
			# We are private person
			if (client.person.nr != 'null')
				@students = 1
				@normal = 0
			else # The person is not a student
				@students = 0
				@normal = 1
			end
		end 
	end

	def to_s
		"#{(@client.id)}, #{(@conference.id)}, #{@cday.id}, #{@students}, #{@normal}"
	end

	def export 
		"exec dbo.DodajRezerwacjeKonf #{to_s}"
	end
end
