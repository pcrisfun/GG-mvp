# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

scott = User.new( first_name: "Scott",
                  last_name: "Gerlach",
                  birthday: "1979-06-26 17:00:00",
                  email: "swgerlach@gmail.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                )
scott.skip_confirmation!
scott.admin = true
scott.save!(validate: false)

cheyenne = User.new( first_name: "Cheyenne",
                  last_name: "Weaver",
                  birthday: "1979-09-22 17:00:00",
                  email: "cheyenneweaver@gmail.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                )
cheyenne.skip_confirmation!
cheyenne.admin = true
cheyenne.save!(validate: false)

diana = User.new( first_name: "Diana",
                  last_name: "Griffin",
                  birthday: "1982-03-07 17:00:00",
                  email: "dianadgriffin@gmail.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                )
diana.skip_confirmation!
diana.admin = true
diana.save!(validate: false)

artist = User.new( first_name: "Martha",
                  last_name: "Smith",
                  birthday: "1980-08-08 17:00:00",
                  email: "artist@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                )
artist.skip_confirmation!
artist.save!(validate: false)

girl = User.new( first_name: "Tina",
                  last_name: "Jones",
                  birthday: "1997-01-01 17:00:00",
                  email: "girl@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                )
girl.skip_confirmation!
girl.save!(validate: false)

kid = User.new( first_name: "Lil",
                  last_name: "Kauffman",
                  birthday: "2007-01-01 17:00:00",
                  email: "kid@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                )
kid.skip_confirmation!
kid.save!(validate: false)

lee = User.new( first_name: "Lee",
                  last_name: "Webster",
                  birthday: "1980-01-01 17:00:00",
                  email: "lee.kerby.webster@gmail.com",
                  password: "leewebster",
                  password_confirmation: "leewebster",
                  terms_of_service: true,
                )
lee.skip_confirmation!
lee.save!(validate: false)

stacey = User.new( first_name: "Stacey",
                  last_name: "Blackman",
                  birthday: "1980-01-01 17:00:00",
                  email: "schoolhouseaustin@gmail.com",
                  password: "staceyblackman",
                  password_confirmation: "staceyblackman",
                  terms_of_service: true,
                )
stacey.skip_confirmation!
stacey.save!(validate: false)

leah = User.new( first_name: "Leah",
                  last_name: "Overstreet",
                  birthday: "1980-01-01 17:00:00",
                  email: "leahoverstreet@gmail.com",
                  password: "leahoverstreet",
                  password_confirmation: "leahoverstreet",
                  terms_of_service: true,
                )
leah.skip_confirmation!
leah.save!(validate: false)

natalie = User.new( first_name: "Natalie",
                  last_name: "Davis",
                  birthday: "1980-01-01 17:00:00",
                  email: "natalie@canoegoods.com",
                  password: "nataliedavis",
                  password_confirmation: "nataliedavis",
                  terms_of_service: true,
                )
natalie.skip_confirmation!
natalie.save!(validate: false)

jodi = User.new( first_name: "Jodi",
                  last_name: "Brownstein",
                  birthday: "1980-01-01 17:00:00",
                  email: "jodi@jodiraedesigns.com",
                  password: "jodibrownstein",
                  password_confirmation: "jodibrownstein",
                  terms_of_service: true,
                )
jodi.skip_confirmation!
jodi.save!(validate: false)

jennie = User.new( first_name: "Jennie",
                  last_name: "Gray",
                  birthday: "1980-01-01 17:00:00",
                  email: "ms.jennie.gray@gmail.com",
                  password: "jenniegray",
                  password_confirmation: "jenniegray",
                  terms_of_service: true,
                )
jennie.skip_confirmation!
jennie.save!(validate: false)

julia = User.new( first_name: "Julia",
                  last_name: "Ward",
                  birthday: "1980-01-01 17:00:00",
                  email: "julia.parmenter@gmail.com",
                  password: "juliaward",
                  password_confirmation: "juliaward",
                  terms_of_service: true,
                )
julia.skip_confirmation!
julia.save!(validate: false)

katy = User.new( first_name: "Katy",
                  last_name: "Dougharty",
                  birthday: "1980-01-01 17:00:00",
                  email: "kdglass.studio@gmail.com",
                  password: "katydougharty",
                  password_confirmation: "katydougharty",
                  terms_of_service: true,
                )
katy.skip_confirmation!
katy.save!(validate: false)

lisa = User.new( first_name: "Lisa",
                  last_name: "Chouinard",
                  birthday: "1980-01-01 17:00:00",
                  email: "lisa@fetosoap.com",
                  password: "lisachouinard",
                  password_confirmation: "lisachouinard",
                  terms_of_service: true,
                )
lisa.skip_confirmation!
lisa.save!(validate: false)

christine = User.new( first_name: "Christine",
                  last_name: "Fail",
                  birthday: "1980-01-01 17:00:00",
                  email: "christine@schatzeleinaustin.com",
                  password: "christinefail",
                  password_confirmation: "christinefail",
                  terms_of_service: true,
                )
christine.skip_confirmation!
christine.save!(validate: false)

jeannie = User.new( first_name: "Jeannie",
                  last_name: "Vianney",
                  birthday: "1980-01-01 17:00:00",
                  email: "jeannie@byjeannie.com",
                  password: "jeannievianney",
                  password_confirmation: "jeannievianney",
                  terms_of_service: true,
                )
jeannie.skip_confirmation!
jeannie.save!(validate: false)

maura = User.new( first_name: "Maura",
                  last_name: "Ambrose",
                  birthday: "1980-01-01 17:00:00",
                  email: "maura@folkfibers.com",
                  password: "mauraambrose",
                  password_confirmation: "mauraambrose",
                  terms_of_service: true,
                )
maura.skip_confirmation!
maura.save!(validate: false)

caroline = User.new( first_name: "Caroline",
                  last_name: "Wright",
                  birthday: "1980-01-01 17:00:00",
                  email: "caroline@carolinewrightart.com",
                  password: "carolinewright",
                  password_confirmation: "carolinewright",
                  terms_of_service: true,
                )
caroline.skip_confirmation!
caroline.save!(validate: false)

callen = User.new( first_name: "Callen",
                  last_name: "Thompson",
                  birthday: "1980-01-01 17:00:00",
                  email: "calliehelen@gmail.com",
                  password: "callenthompson",
                  password_confirmation: "callenthompson",
                  terms_of_service: true,
                )
callen.skip_confirmation!
callen.save!(validate: false)

elizabeth = User.new( first_name: "Elizabeth",
                  last_name: "Chiles",
                  birthday: "1980-01-01 17:00:00",
                  email: "echiles@gmail.com",
                  password: "elizabethchiles",
                  password_confirmation: "elizabethchiles",
                  terms_of_service: true,
                )
elizabeth.skip_confirmation!
elizabeth.save!(validate: false)

ann = User.new( first_name: "Ann",
                  last_name: "Armstrong",
                  birthday: "1980-01-01 17:00:00",
                  email: "ann.armstrong@yahoo.com",
                  password: "annarmstrong",
                  password_confirmation: "annarmstrong",
                  terms_of_service: true,
                )
ann.skip_confirmation!
ann.save!(validate: false)

anna = User.new( first_name: "Anna",
                  last_name: "Gieselman",
                  birthday: "1980-01-01 17:00:00",
                  email: "anna@rarewears.com",
                  password: "annagieselman",
                  password_confirmation: "annagieselman",
                  terms_of_service: true,
                )
anna.skip_confirmation!
anna.save!(validate: false)

adrienne = User.new( first_name: "Adrienne",
                  last_name: "Butler",
                  birthday: "1980-01-01 17:00:00",
                  email: "niceisdifferent@gmail.com",
                  password: "adriennebutler",
                  password_confirmation: "adriennebutler",
                  terms_of_service: true,
                )
adrienne.skip_confirmation!
adrienne.save!(validate: false)

jessica = User.new( first_name: "Jessica",
                  last_name: "Tata",
                  birthday: "1980-01-01 17:00:00",
                  email: "jessica@sonofasailorjewelry.com",
                  password: "jessicatata",
                  password_confirmation: "jessicatata",
                  terms_of_service: true,
                )
jessica.skip_confirmation!
jessica.save!(validate: false)

madelyn = User.new( first_name: "Madelyn",
                  last_name: "Thompson",
                  birthday: "1980-01-01 17:00:00",
                  email: "thompson.madelyn@gmail.com",
                  password: "madelynthompson",
                  password_confirmation: "madelynthompson",
                  terms_of_service: true,
                )
madelyn.skip_confirmation!
madelyn.save!(validate: false)

tahila = User.new( first_name: "Tahila",
                  last_name: "Mintz",
                  birthday: "1980-01-01 17:00:00",
                  email: "totahila@gmail.com",
                  password: "tahilamintz",
                  password_confirmation: "tahilamintz",
                  terms_of_service: true,
                )
tahila.skip_confirmation!
tahila.save!(validate: false)

teruko = User.new( first_name: "Teruko",
                  last_name: "Nimura",
                  birthday: "1980-01-01 17:00:00",
                  email: "terukonimura@gmail.com",
                  password: "terukonimura",
                  password_confirmation: "terukonimura",
                  terms_of_service: true,
                )
teruko.skip_confirmation!
teruko.save!(validate: false)

melissa = User.new( first_name: "Melissa",
                  last_name: "Chapman",
                  birthday: "1980-01-01 17:00:00",
                  email: "melissalynnchapman@gmail.com",
                  password: "melissachapman",
                  password_confirmation: "melissachapman",
                  terms_of_service: true,
                )
melissa.skip_confirmation!
melissa.save!(validate: false)

first_workshop = artist.workshops.create!(              "host_firstname"=>"Martha",
                                                        "host_lastname"=>"Smith",
                                                        "host_business"=>"MS Designs",
                                                        "bio"=>"Vivamus ut accumsan nulla. Maecenas consequat vestibulum dapibus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at purus urna. Sed adipiscing risus non elit molestie eget tempus massa porta. Ut in ligula elit. ",
                                                        "website"=>"msdesigns.com",
                                                        "webshop"=>"shop.msdesigns.com",
                                                        "facebook"=>"marthasmith",
                                                        "twitter"=>"marthasmith",
                                                        "topic"=>"Sculpture with Paper",
                                                        "description"=>" Nam hendrerit eleifend tristique. Donec sed odio orci. Phasellus eu nibh eros, ut malesuada dui. Vestibulum ac convallis ante. Aliquam placerat aliquet mauris ac pellentesque. Suspendisse non turpis in erat fermentum sollicitudin sed ac lectus. Ut vitae bibendum quam. Pellentesque at dui sem. Ut vitae risus leo, at commodo risus. Nulla interdum molestie imperdiet. Nam ut gravida leo. Nunc sit amet nisl nibh, quis mattis mi. Fusce et pharetra mi. Mauris magna lectus, posuere in aliquam nec, sodales eget enim. Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
                                                        "skill_list"=>"'sketching','critical analysis'",
                                                        "tool_list"=>"'paper','exacto blades','adhesives'",
                                                        "requirement_list"=>"",
                                                        "other_needs"=>"Wear clothes that can get dirty or an apron",
                                                        "age_min"=>"13", "age_max"=>"45",
                                                        "registration_min"=>"2",
                                                        "registration_max"=>"8",
                                                        "begins_at"=>"01/01/2014",
                                                        "begins_at_time"=>"10:15 AM",
                                                        "ends_at_time"=>"12:15 PM",
                                                        "datetime_tba"=>"1",
                                                        "location_address"=>"1309 Chestnut Ave.",
                                                        "location_address2"=>"",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78702",
                                                        "location_private"=>"0",
                                                        "location_nbrhood"=>"Chestnut",
                                                        "price"=>"65",
                                                        "ends_at"=>"12/01/2013",
                                                        "payment_options"=>"Paypal",
                                                        "paypal_email"=>"artist@girlsguild.com",
                                                        "sendcheck_address"=>"",
                                                        "sendcheck_address2"=>"",
                                                        "sendcheck_city"=>"",
                                                        "sendcheck_state"=>"",
                                                        "sendcheck_zip"=>"",
                                                        "respect_my_style"=>"0",
                                                        "permission"=>"1"
                                                      )

first_workshop = artist.workshops.create!(              "host_firstname"=>"Martha",
                                                        "host_lastname"=>"Smith",
                                                        "host_business"=>"MS Designs",
                                                        "bio"=>"Vivamus ut accumsan nulla. Maecenas consequat vestibulum dapibus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at purus urna. Sed adipiscing risus non elit molestie eget tempus massa porta. Ut in ligula elit. ",
                                                        "website"=>"msdesigns.com",
                                                        "webshop"=>"shop.msdesigns.com",
                                                        "facebook"=>"marthasmith",
                                                        "twitter"=>"marthasmith",
                                                        "topic"=>"Toy Making",
                                                        "description"=>" Nam hendrerit eleifend tristique. Donec sed odio orci. Phasellus eu nibh eros, ut malesuada dui. Vestibulum ac convallis ante. Aliquam placerat aliquet mauris ac pellentesque. Suspendisse non turpis in erat fermentum sollicitudin sed ac lectus. Ut vitae bibendum quam. Pellentesque at dui sem. Ut vitae risus leo, at commodo risus. Nulla interdum molestie imperdiet. Nam ut gravida leo. Nunc sit amet nisl nibh, quis mattis mi. Fusce et pharetra mi. Mauris magna lectus, posuere in aliquam nec, sodales eget enim. Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
                                                        "skill_list"=>"'sketching','critical analysis'",
                                                        "tool_list"=>"'paper','exacto blades','adhesives'",
                                                        "requirement_list"=>"",
                                                        "other_needs"=>"Wear clothes that can get dirty or an apron",
                                                        "age_min"=>"05", "age_max"=>"11",
                                                        "registration_min"=>"2",
                                                        "registration_max"=>"8",
                                                        "begins_at"=>"01/01/2014",
                                                        "begins_at_time"=>"10:15 AM",
                                                        "ends_at_time"=>"12:15 PM",
                                                        "datetime_tba"=>"1",
                                                        "location_address"=>"1309 Chestnut Ave.",
                                                        "location_address2"=>"",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78702",
                                                        "location_private"=>"0",
                                                        "location_nbrhood"=>"Chestnut",
                                                        "price"=>"65",
                                                        "ends_at"=>"12/01/2013",
                                                        "payment_options"=>"Paypal",
                                                        "paypal_email"=>"artist@girlsguild.com",
                                                        "sendcheck_address"=>"",
                                                        "sendcheck_address2"=>"",
                                                        "sendcheck_city"=>"",
                                                        "sendcheck_state"=>"",
                                                        "sendcheck_zip"=>"",
                                                        "respect_my_style"=>"0",
                                                        "permission"=>"1"
                                                      )

first_workshop = artist.workshops.create!(              "host_firstname"=>"Martha",
                                                        "host_lastname"=>"Smith",
                                                        "host_business"=>"MS Designs",
                                                        "bio"=>"Vivamus ut accumsan nulla. Maecenas consequat vestibulum dapibus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at purus urna. Sed adipiscing risus non elit molestie eget tempus massa porta. Ut in ligula elit. ",
                                                        "website"=>"msdesigns.com",
                                                        "webshop"=>"shop.msdesigns.com",
                                                        "facebook"=>"marthasmith",
                                                        "twitter"=>"marthasmith",
                                                        "topic"=>"Advanced Techniques in Photography",
                                                        "description"=>" Nam hendrerit eleifend tristique. Donec sed odio orci. Phasellus eu nibh eros, ut malesuada dui. Vestibulum ac convallis ante. Aliquam placerat aliquet mauris ac pellentesque. Suspendisse non turpis in erat fermentum sollicitudin sed ac lectus. Ut vitae bibendum quam. Pellentesque at dui sem. Ut vitae risus leo, at commodo risus. Nulla interdum molestie imperdiet. Nam ut gravida leo. Nunc sit amet nisl nibh, quis mattis mi. Fusce et pharetra mi. Mauris magna lectus, posuere in aliquam nec, sodales eget enim. Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
                                                        "skill_list"=>"'sketching','critical analysis'",
                                                        "tool_list"=>"'paper','exacto blades','adhesives'",
                                                        "requirement_list"=>"",
                                                        "other_needs"=>"Wear clothes that can get dirty or an apron",
                                                        "age_min"=>"20", "age_max"=>"99",
                                                        "registration_min"=>"2",
                                                        "registration_max"=>"8",
                                                        "begins_at"=>"01/01/2014",
                                                        "begins_at_time"=>"10:15 AM",
                                                        "ends_at_time"=>"12:15 PM",
                                                        "datetime_tba"=>"1",
                                                        "location_address"=>"1309 Chestnut Ave.",
                                                        "location_address2"=>"",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78702",
                                                        "location_private"=>"0",
                                                        "location_nbrhood"=>"Chestnut",
                                                        "price"=>"65",
                                                        "ends_at"=>"12/01/2013",
                                                        "payment_options"=>"Paypal",
                                                        "paypal_email"=>"artist@girlsguild.com",
                                                        "sendcheck_address"=>"",
                                                        "sendcheck_address2"=>"",
                                                        "sendcheck_city"=>"",
                                                        "sendcheck_state"=>"",
                                                        "sendcheck_zip"=>"",
                                                        "respect_my_style"=>"0",
                                                        "permission"=>"1"
                                                      )

first_workshop = artist.workshops.create!(              "host_firstname"=>"Martha",
                                                        "host_lastname"=>"Smith",
                                                        "host_business"=>"MS Designs",
                                                        "bio"=>"Vivamus ut accumsan nulla. Maecenas consequat vestibulum dapibus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at purus urna. Sed adipiscing risus non elit molestie eget tempus massa porta. Ut in ligula elit. ",
                                                        "website"=>"msdesigns.com",
                                                        "webshop"=>"shop.msdesigns.com",
                                                        "facebook"=>"marthasmith",
                                                        "twitter"=>"marthasmith",
                                                        "topic"=>"Experimental Painting",
                                                        "description"=>" Nam hendrerit eleifend tristique. Donec sed odio orci. Phasellus eu nibh eros, ut malesuada dui. Vestibulum ac convallis ante. Aliquam placerat aliquet mauris ac pellentesque. Suspendisse non turpis in erat fermentum sollicitudin sed ac lectus. Ut vitae bibendum quam. Pellentesque at dui sem. Ut vitae risus leo, at commodo risus. Nulla interdum molestie imperdiet. Nam ut gravida leo. Nunc sit amet nisl nibh, quis mattis mi. Fusce et pharetra mi. Mauris magna lectus, posuere in aliquam nec, sodales eget enim. Lorem ipsum dolor sit amet, consectetur adipiscing elit. ",
                                                        "skill_list"=>"'sketching','critical analysis'",
                                                        "tool_list"=>"'paper','exacto blades','adhesives'",
                                                        "requirement_list"=>"",
                                                        "other_needs"=>"Wear clothes that can get dirty or an apron",
                                                        "age_min"=>"15", "age_max"=>"80",
                                                        "registration_min"=>"2",
                                                        "registration_max"=>"8",
                                                        "begins_at"=>"01/01/2014",
                                                        "begins_at_time"=>"10:15 AM",
                                                        "ends_at_time"=>"12:15 PM",
                                                        "datetime_tba"=>"1",
                                                        "location_address"=>"1309 Chestnut Ave.",
                                                        "location_address2"=>"",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78702",
                                                        "location_private"=>"0",
                                                        "location_nbrhood"=>"Chestnut",
                                                        "price"=>"65",
                                                        "ends_at"=>"12/01/2013",
                                                        "payment_options"=>"Paypal",
                                                        "paypal_email"=>"artist@girlsguild.com",
                                                        "sendcheck_address"=>"",
                                                        "sendcheck_address2"=>"",
                                                        "sendcheck_city"=>"",
                                                        "sendcheck_state"=>"",
                                                        "sendcheck_zip"=>"",
                                                        "respect_my_style"=>"0",
                                                        "permission"=>"1"
                                                      )




first_apprenticeship = artist.apprenticeships.create!(  "host_firstname"=>"Martha",
                                                        "host_lastname"=>"Smith",
                                                        "host_business"=>"MS Designs",
                                                        "kind" => "event",
                                                        "bio"=>"Vivamus ut accumsan nulla. Maecenas consequat vestibulum dapibus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at purus urna. Sed adipiscing risus non elit molestie eget tempus massa porta. Ut in ligula elit. ",
                                                        "website"=>"msdesigns.com",
                                                        "webshop"=>"shop.msdesigns.com",
                                                        "facebook"=>"marthasmith",
                                                        "twitter"=>"martha_smith",
                                                        "topic"=>"Sculpture Creation",
                                                        "kind"=>"Production",
                                                        "description"=>"Quisque in ligula id arcu fringilla gravida a vel purus. Etiam tempus hendrerit augue, vel luctus metus egestas quis. Morbi sit amet felis non purus rutrum adipiscing. Proin aliquet sapien at tellus hendrerit eget cursus orci cursus. Donec turpis sem, ullamcorper eget sodales non, vulputate nec dolor. Proin tortor metus, fringilla eget tristique eu, gravida nec mi. Quisque vitae quam magna, hendrerit sollicitudin metus. Nulla quis purus justo, eget porttitor turpis. Donec fringilla ullamcorper risus vitae lobortis. Sed vitae lacus neque, adipiscing eleifend nisl. Phasellus faucibus erat eget justo luctus consectetur. Curabitur sed venenatis nisi. Suspendisse potenti. ",
                                                        "skill_list"=>"'Paper Sculpting','Sketching','circular sander'",
                                                        "tool_list"=>"'Adhesive','exacto blades','sand paper'",
                                                        "requirement_list"=>"'some comfort with electric tools and blades'",
                                                        "other_needs"=>"Have their own transportation",
                                                        "age_min"=>"16",
                                                        "age_max"=>"25",
                                                        "registration_max"=>"2",
                                                        "begins_at"=>"06/01/2013",
                                                        "ends_at"=>"12/01/2013",
                                                        "datetime_tba"=>"0",
                                                        "hours"=>"4",
                                                        "hours_per"=>"week",
                                                        "location_address"=>"615 W Johanna St",
                                                        "location_address2"=>"",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78704",
                                                        "location_private"=>"1",
                                                        "location_nbrhood"=>"Bouldin Creek",
                                                        "location_varies"=>"0",
                                                        "respect_my_style"=>"1",
                                                        "stripe_card_token"=>"",
                                                        "permission"=>"1",
                                                        "availability"=>"M-F, 3-7pm. Flexible on weekend days."
                                                     )
second_apprenticeship = artist.apprenticeships.create!(  "host_firstname"=>"Martha",
                                                        "host_lastname"=>"Smith",
                                                        "host_business"=>"MS Designs",
                                                        "kind" => "production",
                                                        "bio"=>"Vivamus ut accumsan nulla. Maecenas consequat vestibulum dapibus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at purus urna. Sed adipiscing risus non elit molestie eget tempus massa porta. Ut in ligula elit. ",
                                                        "website"=>"msdesigns.com",
                                                        "webshop"=>"shop.msdesigns.com",
                                                        "facebook"=>"marthasmith",
                                                        "twitter"=>"martha_smith",
                                                        "topic"=>"Kids Craft",
                                                        "kind"=>"Ongoing",
                                                        "description"=>"Quisque in ligula id arcu fringilla gravida a vel purus. Etiam tempus hendrerit augue, vel luctus metus egestas quis. Morbi sit amet felis non purus rutrum adipiscing. Proin aliquet sapien at tellus hendrerit eget cursus orci cursus. Donec turpis sem, ullamcorper eget sodales non, vulputate nec dolor. Proin tortor metus, fringilla eget tristique eu, gravida nec mi. Quisque vitae quam magna, hendrerit sollicitudin metus. Nulla quis purus justo, eget porttitor turpis. Donec fringilla ullamcorper risus vitae lobortis. Sed vitae lacus neque, adipiscing eleifend nisl. Phasellus faucibus erat eget justo luctus consectetur. Curabitur sed venenatis nisi. Suspendisse potenti. ",
                                                        "skill_list"=>"'Paper Sculpting','Sketching','circular sander'",
                                                        "tool_list"=>"'Adhesive','exacto blades','sand paper'",
                                                        "requirement_list"=>"'some comfort with electric tools and blades'",
                                                        "other_needs"=>"Have their own transportation",
                                                        "age_min"=>"3",
                                                        "age_max"=>"12",
                                                        "registration_max"=>"5",
                                                        "begins_at"=>"06/01/2013",
                                                        "ends_at"=>"12/01/2013",
                                                        "datetime_tba"=>"0",
                                                        "hours"=>"4",
                                                        "hours_per"=>"week",
                                                        "location_address"=>"615 W Johanna St",
                                                        "location_address2"=>"",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78704",
                                                        "location_private"=>"1",
                                                        "location_nbrhood"=>"Cherrywood",
                                                        "location_varies"=>"0",
                                                        "respect_my_style"=>"1",
                                                        "stripe_card_token"=>"",
                                                        "permission"=>"1",
                                                        "availability"=>"Mondays, Wednesdays, and Thursdays, in the afternoon. Usually free on weekend days."
                                                     )
third_apprenticeship = artist.apprenticeships.create!(  "host_firstname"=>"Martha",
                                                        "host_lastname"=>"Smith",
                                                        "host_business"=>"MS Designs",
                                                        "kind" => "ongoing",
                                                        "bio"=>"Vivamus ut accumsan nulla. Maecenas consequat vestibulum dapibus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at purus urna. Sed adipiscing risus non elit molestie eget tempus massa porta. Ut in ligula elit. ",
                                                        "website"=>"msdesigns.com",
                                                        "webshop"=>"shop.msdesigns.com",
                                                        "facebook"=>"marthasmith",
                                                        "twitter"=>"martha_smith",
                                                        "topic"=>"Teenishness",
                                                        "kind"=>"Event",
                                                        "description"=>"Quisque in ligula id arcu fringilla gravida a vel purus. Etiam tempus hendrerit augue, vel luctus metus egestas quis. Morbi sit amet felis non purus rutrum adipiscing. Proin aliquet sapien at tellus hendrerit eget cursus orci cursus. Donec turpis sem, ullamcorper eget sodales non, vulputate nec dolor. Proin tortor metus, fringilla eget tristique eu, gravida nec mi. Quisque vitae quam magna, hendrerit sollicitudin metus. Nulla quis purus justo, eget porttitor turpis. Donec fringilla ullamcorper risus vitae lobortis. Sed vitae lacus neque, adipiscing eleifend nisl. Phasellus faucibus erat eget justo luctus consectetur. Curabitur sed venenatis nisi. Suspendisse potenti. ",
                                                        "skill_list"=>"'Paper Sculpting','Sketching','circular sander'",
                                                        "tool_list"=>"'Adhesive','exacto blades','sand paper'",
                                                        "requirement_list"=>"'some comfort with electric tools and blades'",
                                                        "other_needs"=>"Have their own transportation",
                                                        "age_min"=>"13",
                                                        "age_max"=>"19",
                                                        "registration_max"=>"4",
                                                        "begins_at"=>"06/01/2013",
                                                        "ends_at"=>"12/01/2013",
                                                        "datetime_tba"=>"0",
                                                        "hours"=>"4",
                                                        "hours_per"=>"week",
                                                        "location_address"=>"615 W Johanna St",
                                                        "location_address2"=>"",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78704",
                                                        "location_private"=>"1",
                                                        "location_nbrhood"=>"Eanes",
                                                        "location_varies"=>"0",
                                                        "respect_my_style"=>"1",
                                                        "stripe_card_token"=>"",
                                                        "permission"=>"1",
                                                        "availability"=>"M-F, 3-7pm. Flexible on weekend days."
                                                     )
fourth_apprenticeship = artist.apprenticeships.create!(  "host_firstname"=>"Martha",
                                                        "host_lastname"=>"Smith",
                                                        "host_business"=>"MS Designs",
                                                        "kind" => "event",
                                                        "bio"=>"Vivamus ut accumsan nulla. Maecenas consequat vestibulum dapibus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at purus urna. Sed adipiscing risus non elit molestie eget tempus massa porta. Ut in ligula elit. ",
                                                        "website"=>"msdesigns.com",
                                                        "webshop"=>"shop.msdesigns.com",
                                                        "facebook"=>"marthasmith",
                                                        "twitter"=>"martha_smith",
                                                        "topic"=>"All Ages",
                                                        "kind"=>"Event",
                                                        "description"=>"Quisque in ligula id arcu fringilla gravida a vel purus. Etiam tempus hendrerit augue, vel luctus metus egestas quis. Morbi sit amet felis non purus rutrum adipiscing. Proin aliquet sapien at tellus hendrerit eget cursus orci cursus. Donec turpis sem, ullamcorper eget sodales non, vulputate nec dolor. Proin tortor metus, fringilla eget tristique eu, gravida nec mi. Quisque vitae quam magna, hendrerit sollicitudin metus. Nulla quis purus justo, eget porttitor turpis. Donec fringilla ullamcorper risus vitae lobortis. Sed vitae lacus neque, adipiscing eleifend nisl. Phasellus faucibus erat eget justo luctus consectetur. Curabitur sed venenatis nisi. Suspendisse potenti. ",
                                                        "skill_list"=>"'Paper Sculpting','Sketching','circular sander'",
                                                        "tool_list"=>"'Adhesive','exacto blades','sand paper'",
                                                        "requirement_list"=>"'some comfort with electric tools and blades'",
                                                        "other_needs"=>"Have their own transportation",
                                                        "age_min"=>"1",
                                                        "age_max"=>"100",
                                                        "registration_max"=>"13",
                                                        "begins_at"=>"06/01/2013",
                                                        "ends_at"=>"12/01/2013",
                                                        "datetime_tba"=>"0",
                                                        "hours"=>"4",
                                                        "hours_per"=>"week",
                                                        "location_address"=>"615 W Johanna St",
                                                        "location_address2"=>"",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78704",
                                                        "location_private"=>"1",
                                                        "location_nbrhood"=>"Spicewood",
                                                        "location_varies"=>"0",
                                                        "respect_my_style"=>"1",
                                                        "stripe_card_token"=>"",
                                                        "permission"=>"1",
                                                        "availability"=>"M-F, 3-7pm. Flexible on weekend days."
                                                     )
fifth_apprenticeship = artist.apprenticeships.create!(  "host_firstname"=>"Martha",
                                                        "host_lastname"=>"Smith",
                                                        "host_business"=>"MS Designs",
                                                        "kind" => "event",
                                                        "bio"=>"Vivamus ut accumsan nulla. Maecenas consequat vestibulum dapibus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at purus urna. Sed adipiscing risus non elit molestie eget tempus massa porta. Ut in ligula elit. ",
                                                        "website"=>"msdesigns.com",
                                                        "webshop"=>"shop.msdesigns.com",
                                                        "facebook"=>"marthasmith",
                                                        "twitter"=>"martha_smith",
                                                        "topic"=>"Come One Come All",
                                                        "kind"=>"Ongoing",
                                                        "description"=>"Quisque in ligula id arcu fringilla gravida a vel purus. Etiam tempus hendrerit augue, vel luctus metus egestas quis. Morbi sit amet felis non purus rutrum adipiscing. Proin aliquet sapien at tellus hendrerit eget cursus orci cursus. Donec turpis sem, ullamcorper eget sodales non, vulputate nec dolor. Proin tortor metus, fringilla eget tristique eu, gravida nec mi. Quisque vitae quam magna, hendrerit sollicitudin metus. Nulla quis purus justo, eget porttitor turpis. Donec fringilla ullamcorper risus vitae lobortis. Sed vitae lacus neque, adipiscing eleifend nisl. Phasellus faucibus erat eget justo luctus consectetur. Curabitur sed venenatis nisi. Suspendisse potenti. ",
                                                        "skill_list"=>"'Paper Sculpting','Sketching','circular sander'",
                                                        "tool_list"=>"'Adhesive','exacto blades','sand paper'",
                                                        "requirement_list"=>"'some comfort with electric tools and blades'",
                                                        "other_needs"=>"Have their own transportation",
                                                        "age_min"=>"1",
                                                        "age_max"=>"100",
                                                        "registration_max"=>"3",
                                                        "begins_at"=>"06/01/2013",
                                                        "ends_at"=>"12/01/2013",
                                                        "datetime_tba"=>"0",
                                                        "hours"=>"4",
                                                        "hours_per"=>"week",
                                                        "location_address"=>"615 W Johanna St",
                                                        "location_address2"=>"",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78704",
                                                        "location_private"=>"1",
                                                        "location_nbrhood"=>"Travis Heights",
                                                        "location_varies"=>"0",
                                                        "respect_my_style"=>"1",
                                                        "stripe_card_token"=>"",
                                                        "permission"=>"1",
                                                        "availability"=>"M-F, 3-7pm. Flexible on weekend days."
                                                     )
sixth_apprenticeship = artist.apprenticeships.create!(  "host_firstname"=>"Martha",
                                                        "host_lastname"=>"Smith",
                                                        "host_business"=>"MS Designs",
                                                        "kind" => "production",
                                                        "bio"=>"Vivamus ut accumsan nulla. Maecenas consequat vestibulum dapibus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at purus urna. Sed adipiscing risus non elit molestie eget tempus massa porta. Ut in ligula elit. ",
                                                        "website"=>"msdesigns.com",
                                                        "webshop"=>"shop.msdesigns.com",
                                                        "facebook"=>"marthasmith",
                                                        "twitter"=>"martha_smith",
                                                        "topic"=>"Everyone Allowed",
                                                        "kind"=>"Ongoing",
                                                        "description"=>"Quisque in ligula id arcu fringilla gravida a vel purus. Etiam tempus hendrerit augue, vel luctus metus egestas quis. Morbi sit amet felis non purus rutrum adipiscing. Proin aliquet sapien at tellus hendrerit eget cursus orci cursus. Donec turpis sem, ullamcorper eget sodales non, vulputate nec dolor. Proin tortor metus, fringilla eget tristique eu, gravida nec mi. Quisque vitae quam magna, hendrerit sollicitudin metus. Nulla quis purus justo, eget porttitor turpis. Donec fringilla ullamcorper risus vitae lobortis. Sed vitae lacus neque, adipiscing eleifend nisl. Phasellus faucibus erat eget justo luctus consectetur. Curabitur sed venenatis nisi. Suspendisse potenti. ",
                                                        "skill_list"=>"'Paper Sculpting','Sketching','circular sander'",
                                                        "tool_list"=>"'Adhesive','exacto blades','sand paper'",
                                                        "requirement_list"=>"'some comfort with electric tools and blades'",
                                                        "other_needs"=>"Have their own transportation",
                                                        "age_min"=>"1",
                                                        "age_max"=>"100",
                                                        "registration_max"=>"30",
                                                        "begins_at"=>"06/01/2013",
                                                        "ends_at"=>"12/01/2013",
                                                        "datetime_tba"=>"0",
                                                        "hours"=>"4",
                                                        "hours_per"=>"week",
                                                        "location_address"=>"615 W Johanna St",
                                                        "location_address2"=>"",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78704",
                                                        "location_private"=>"1",
                                                        "location_nbrhood"=>"Westlake Hills",
                                                        "location_varies"=>"0",
                                                        "respect_my_style"=>"1",
                                                        "stripe_card_token"=>"",
                                                        "permission"=>"1",
                                                        "availability"=>"M-F, 3-7pm. Flexible on weekend days."
                                                     )
Event.all.each do |event|
  event.generate_title
end


