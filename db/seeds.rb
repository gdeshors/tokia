# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


user1 = User.create(name:"Guillaume", email:"a@a.com", password: "aaaaaa", password_confirmation: "aaaaaa")

ai1 = Ai.create(name:"devastatok", active: true, elo: 1500, version: "1.0", user: user1)



user2 = User.create(name:"Toto", email:"b@b.com", password: "bbbbbb", password_confirmation: "bbbbbb")

ai2 = Ai.create(name:"devastée", active: true, elo: 1500, version: "1.0", user: user2)


Match.create(ai_1: ai1, ai_2: ai2, winner1: ai1, winner2: ai1, winner: ai1, log1:"A SORT\nA FIN")

