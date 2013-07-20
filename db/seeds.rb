# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
flights = [{
    depart_time_hour: 600,
    arrive_time_hour: 700,

    passengers: [
        {
            user_id: 1,
            request: true    
        }
    ]
}]

trip = Trip.create(
  {

    flights: {flights: 'somestring'}
  }
)
