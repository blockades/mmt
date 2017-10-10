# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Member.destroy_all

Member.create email: 'admin@mmt.blockades.org', password: 'admin123', admin: true
Member.create email: 'bob.j.bobess@farcical.net', password: '123456'
Member.create email: 'j.a.funky@hotmail.net', password: '123456'
Member.create email: 'danny@jman.net', password: '123456'

