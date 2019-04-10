# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#Add admin user

#Add default task statuses
User.create(username: 'admin', password: 'password', admin: true)

done = TaskStatus.create(title: 'Done', description: "This task has been completed.", color: '#55FF55' )
in_progress = TaskStatus.create(title: 'In Progress', description: "Somebody is working on this task.", requires_action: true, color: '#FFCC55', next_statuses: [done])
TaskStatus.create(title: 'Incomplete', description: "The default status for any newly created task. Implies that nobody is working on this yet.", color: '#FF5555', requires_action: true, default_apply: true, next_statuses: [in_progress])
