# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Page.create([{ name: 'root1', content_raw: 'content', header: 'root1 header' },
             { name: 'firstborn1', content_raw: 'content', header: 'firstborn1 header', parent_page_id: 1 },
             { name: 'firstborn2', content_raw: 'content', header: 'firstborn2 header', parent_page_id: 1 },
             { name: 'secondborn1', content_raw: 'content', header: 'secondborn1 header', parent_page_id: 2 },
             { name: 'secondborn2', content_raw: 'content', header: 'secondborn2 header', parent_page_id: 2 },
             { name: 'secondborn3', content_raw: 'content', header: 'secondborn3 header', parent_page_id: 2 },
             { name: 'thirdborn1', content_raw: 'content', header: 'thirdborn1 header', parent_page_id: 4 },
             { name: 'thirdborn2', content_raw: 'content', header: 'thirdborn2 header', parent_page_id: 4 }])
