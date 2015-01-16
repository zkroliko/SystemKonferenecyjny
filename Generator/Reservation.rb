#Reservation for conference
require_relative 'Workshop'

RESERVATION_BASE_QUOTA = 0.05
RESERVATION_VARY_QUOTA = 0.05

RESERVATION_BASE_QUOTA_WORKSHOP = 0.1
RESERVATION_VARY_QUOTA_WORKSHOP = 0.1

RESERVATION_DATE_BASE = 14 # In days
RESERVATION_DATE_VARY = 500 # In days

STUDENT_PROPORTION = 0.1

class CReservation

	@@curindex = 1

	attr_accessor :curindex, :id, :cday, :client, :reservationDate

	def initialize(client, cday)
		@id = @@curindex
		@@curindex +=1
		@client = client		
		@cday = cday
		@reservationDate = ((@cday.date)-(rand()*RESERVATION_DATE_VARY+RESERVATION_DATE_BASE).to_i) # Randomizing reservation day
		@conference = @cday.conference
		# Now let's make a decision on number of places on the reservation
		# The ammount of places is randomized based on constants
		# , the @leftPlaces field of conference is updated
		if (@client.instance_of?(CompanyClient) and @conference.leftPlaces > 0)
			# We are comapny aparently
			places = (@conference.places*(RESERVATION_VARY_QUOTA*rand()+RESERVATION_BASE_QUOTA))%(@conference.leftPlaces)
			@conference.leftPlaces -= places.to_i # Substracting taken spaces
			if (@conference.leftPlaces <=0)
				return false
			else
			@students = (places*STUDENT_PROPORTION).to_i
			# Lets check whether there is place left for students
			@normal = (places*(1-STUDENT_PROPORTION)).to_i
		end else
			# We are private person
			if (client.person.nr != 'null')
				@students = 1
				@normal = 0
			else # The person is not a student
				@students = 0
				@normal = 1
			end
			@conference.leftPlaces -= 1
		end 
	end

	def to_s
		"#{(@client.id)}, #{(@conference.id)}, \"#{@reservationDate.to_s[0..10]}\", #{@students}, #{@normal}"
	end

	def export 
		"exec dbo.DodajRezerwacjeKonf #{to_s}"
	end
end

class WReservation

	@@curindex = 1

	attr_accessor :curindex, :id, :date, :workshop, :creservation, :client, :places

	def initialize(workshop, creservation, places = 0)
		@id = @@curindex
		@@curindex +=1
		@workshop = workshop
		@creservation = creservation
		@client = creservation.client
		# Now let's make a decision on number of places on the reservation
		# The ammount of places is randomized based on constants
		# , the @leftPlaces field of conference is updated
		if (@client.instance_of?(CompanyClient) and @workshop.leftPlaces > 0)
			# We are comapny aparently
			@places = ((@workshop.places*(RESERVATION_VARY_QUOTA_WORKSHOP*rand()+RESERVATION_BASE_QUOTA_WORKSHOP))%(@workshop.leftPlaces)).to_i
			@workshop.leftPlaces -= @places.to_i # Substracting taken spaces
			if (@workshop.leftPlaces <=0)
				return false
			else
		end else
			# We are an individual person
			@places = 1
			@conference.leftPlaces -= 1
		end 
	end

	def to_s
		"#{(@workshop.id)}, #{@creservation.id}, \"#{(@creservation.reservationDate).to_s[0..10]}\", #{@places}"
	end

	def export 
		"exec dbo.DodajRezerwacjeWarsztatu #{to_s}"
	end
end

#Conference participant
class CParticipant

	@@curindex = 1

	attr_accessor :curindex, :id, :date, :client, :creservation, :person

	def initialize(creservation, person)
		@id = @@curindex
		@@curindex +=1
		@client = creservation.client
		@creservation = creservation
		@person = person
	end

	def to_s
		"#{@client.id}, #{@creservation.id}, #{@person.id}"
	end

	def export 
		"exec dbo.DodajUczestnikaKonf #{to_s}"
	end
end

#Wokshop participant
class WParticipant

	@@curindex = 1

	attr_accessor :curindex, :id, :date, :client, :wreservation, :person

	def initialize(wreservation, cparticipant)
		@id = @@curindex
		@@curindex +=1
		@wreservation = wreservation
		@cparticipant= cparticipant
	end

	def to_s
		"#{@wreservation.id}, #{@cparticipant.id}"
	end

	def export 
		"exec dbo.DodajUczestnika #{to_s}"
	end
end

