# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


user1 = User.create(name:"Demo1", email:"a@a.com", password: "a@a.com", password_confirmation: "a@a.com")

ai1 = Ai.create(name:"tokatietakite113", active: true, elo: 1500, version: "1.0", user: user1,
command_line: "java -cp env/scala_2.10.3/*:/home/tokserver/clients/1/tok-server-1.3.2.jar net.deshors.tok.client.ClientPlateau113",
language: "scala 2.10.3", firstparam: "net.deshors.tok.client.ClientPlateau113")


user2 = User.create(name:"Demo2", email:"b@b.com", password: "b@b.com", password_confirmation: "b@b.com")
ai2 = Ai.create(name:"tokatietakite", active: true, elo: 1500, version: "1.0", user: user2,
command_line: "java -cp env/scala_2.10.3/*:/home/tokserver/clients/1/tok-server-1.3.3.jar net.deshors.tok.client.ClientPlateau113",
language: "scala 2.10.3", firstparam: "net.deshors.tok.client.ClientPlateau")

