# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Activity.destroy_all

Activity.create!([{
  key: 'PHA',
  name: 'Take your health assessment',
  sample_value: true
},
{
  key: 'SCREENING',
  name: 'Perform your screening',
  sample_value: true
},
{
  key: 'STEPS',
  name: '10000 steps',
  sample_value: false
},
{
  key: 'EDUCATION',
  name: 'Watch this educational video',
  sample_value: true
},
{
  key: 'DENTAL',
  name: 'Visit the dentist',
  sample_value: true
},
{
  key: 'FLU',
  name: 'Get your flu shot',
  sample_value: false
},
{
  key: 'WORKOUT',
  name: 'Hit the gym',
  sample_value: false
}])

p "Created #{Activity.count} default activities"
