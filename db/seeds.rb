# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])

teams = %w(
  Atalanta
  Bologna
  Brescia
  Cagliari
  Fiorentina
  Genoa
  Hellas
  Internazionale
  Juventus
  Lazio
  Lecce
  Milan
  Napoli
  Parma
  Roma
  Sampdoria
  Sassuolo
  SPAL
  Torino
  Udinese
)

teams.each do |team|
  ok = Team.create(name: team)
  if !ok
    puts "error creating team: #{team}"
  end
end
