# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


user1 = User.create(name:"Demo1", email:"a@a.com", password: "aaaaaa", password_confirmation: "aaaaaa")

ai1 = Ai.create(name:"Java RM", active: true, elo: 1500, version: "1.0", user: user1,
command_line: "java -cp env/scala_2.10.3/*:server/* net.deshors.tok.client.StarterKitClient" )



user2 = User.create(name:"Demo2", email:"b@b.com", password: "bbbbbb", password_confirmation: "bbbbbb")

ai2 = Ai.create(name:"Scala RM", active: true, elo: 1500, version: "1.0", user: user2)


user3 = User.create(name:"Demo3", email:"c@c.com", password: "bbbbbb", password_confirmation: "bbbbbb")

ai2 = Ai.create(name:"Scala RM2", active: true, elo: 1500, version: "1.0", user: user3,
command_line: "java -cp env/scala_2.10.3/*:server/* net.deshors.tok.client.Client"
)

#Match.create(ai_1: ai1, ai_2: ai2, winner1: ai1, winner2: ai1, winner: ai1, log1:"A SORT\nA FIN\nB SORT\nB FIN\nA DEPLACE A0 B2\nA FIN\nB DEPLACE B0 B2\nB MANGE A B2\nB FIN")

