# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Member.destroy_all

Member.create username: 'theadmin', email: 'admin@blockades.dev', password: 'Gandalf01', admin: true
Member.create username: 'dummy', email: 'dummy@blockades.dev', password: 'Gandalf01'

