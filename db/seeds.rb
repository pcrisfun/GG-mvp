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
artist.admin = false
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
girl.admin = false
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
kid.admin = false
kid.save!(validate: false)

lee = User.new( first_name: "Lee",
                  last_name: "Webster",
                  birthday: "1980-01-01 17:00:00",
                  email: "lee.kerby.webster@gmail.com",
                  password: "leewebster",
                  password_confirmation: "leewebster",
                  terms_of_service: true,
                  bio: "Lee Webster was born in Philadelphia, PA and currently lives and works in Austin, TX. Her practice incorporates film, video, installation and public projects. Her work has been shown at Art House at the Jones Center, Sofa Gallery, Domy Books, and Co-lab in Austin, Sarah Lawrence College in New York, and Danger Danger Gallery in Philadelphia. Her films have been included in screenings at Box 13 in Houston, Portland Oregon Women's Film Festival, Women and Their Work, as part of a special screening for the Texas Biennial and as part of the Fusebox Festival in Austin, TX. Her work as a video designer for theater has won recognition by the Austin Critics Table. She is a working artist, teacher and a founding member of the video art collective, Austin Video Bee.",
                  website: "http://www.leewebster.com",
                  webshop:"",
                  facebook:"",
                  twitter:"",
                )
lee.skip_confirmation!
lee.admin = false
lee.save!(validate: false)

stacey = User.new( first_name: "Stacey",
                  last_name: "Blackman",
                  birthday: "1980-01-01 17:00:00",
                  email: "schoolhouseaustin@gmail.com",
                  password: "staceyblackman",
                  password_confirmation: "staceyblackman",
                  terms_of_service: true,
                  bio: "Stacey Blackman is an artist educator who founded ScHoolHouse Austin to offer skill based workshops in the fine arts, creative culture and design for both children and adults. She studied at Pratt Institute in Brooklyn and the Aegean Center for Fine Arts in Greece. Stacey believes the practice of creating can bring about a new way of experiencing and engaging the world around us. Create happy! ",
                  website: "http://www.schoolhouseaustin.com",
                  webshop: "",
                  facebook: "",
                  twitter: "",
                )
stacey.skip_confirmation!
stacey.admin = false
stacey.save!(validate: false)

leah = User.new( first_name: "Leah",
                  last_name: "Overstreet",
                  birthday: "1980-01-01 17:00:00",
                  email: "leahoverstreet@gmail.com",
                  password: "leahoverstreet",
                  password_confirmation: "leahoverstreet",
                  terms_of_service: true,
                  bio: "I began my career working as a photographer for the Smithsonian's National Zoo in D.C. After moving to NYC, I worked in the photo departments of GQ, Vogue, Men's Journal and MTV Networks. These diverse backgrounds of fashion, celebrity, and adventure, helped me become a more thoughtful and creative photographer.",
                  website:"http://www.leahoverstreet.com",
                  webshop:"",
                  facebook:"",
                  twitter:"",
                )
leah.skip_confirmation!
leah.admin = false
leah.save!(validate: false)

natalie = User.new( first_name: "Natalie",
                  last_name: "Davis",
                  birthday: "1980-01-01 17:00:00",
                  email: "natalie@canoegoods.com",
                  password: "nataliedavis",
                  password_confirmation: "nataliedavis",
                  terms_of_service: true,
                  bio: "Natalie Davis is a designer, artist, and educator. In 2007 she launched Miss Natalie, a collection of home accessories and kids' goods, featuring best sellers like the heirloom growth chart and wooden apple boxes. Her work has been showcased on Design*Sponge, Apartment Therapy, Sunset, and Whole Living, among other publications. Inspired by her move to Austin, Natalie launched Canoe, a line of hand tooled leather accessories. In 2011 she produced five pop up shops and began blogging at Tool & Tack, which highlights artisans and rebels of all kinds.",
                  website: "http://www.canoegoods.com",
                  webshop:"",
                  facebook:"",
                  twitter:"",
                )
natalie.skip_confirmation!
natalie.admin = false
natalie.save!(validate: false)

jodi = User.new( first_name: "Jodi",
                  last_name: "Brownstein",
                  birthday: "1980-01-01 17:00:00",
                  email: "jodi@jodiraedesigns.com",
                  password: "jodibrownstein",
                  password_confirmation: "jodibrownstein",
                  terms_of_service: true,
                  bio: "I am an artist who has been making and selling my own handcrafted jewelry since the age of 8. My art has become not just my passion, but also my life's work, and I am thrilled to share it with you. I have spent the past few decades honing and developing my own versatile style of jewelry using sterling silver, 18- and 22-karat gold, semiprecious and precious gems, and many different kinds of minerals and stones. I have always been drawn to rare and unique stones in nature, and I pride myself on finding the most strikingly beautiful specimens to use in my pieces.",
                  website: "http://www.jodiraedesigns.com",
                  webshop:"",
                  facebook:"",
                  twitter:"",
                )
jodi.skip_confirmation!
jodi.admin = false
jodi.save!(validate: false)

jennie = User.new( first_name: "Jennie",
                  last_name: "Gray",
                  birthday: "1980-01-01 17:00:00",
                  email: "ms.jennie.gray@gmail.com",
                  password: "jenniegray",
                  password_confirmation: "jenniegray",
                  terms_of_service: true,
                  bio: "Jennie Tudor Gray, named after children's author Tasha Tudor, is an Artist and Arts Educator living in Austin, TX. She graduated magna cum laude from Texas State University with a BFA in Studio Art and All Level Teaching Certification and is passionate about using creative arts education as a method of social change. She enjoys making art out of old books, ephemera, old photos, & found objects.",
                  website: "http://www.jennietudorgray.com"
                  webshop:"",
                  facebook:"",
                  twitter:"",
                )
jennie.skip_confirmation!
jennie.admin = false
jennie.save!(validate: false)

julia = User.new( first_name: "Julia",
                  last_name: "Ward",
                  birthday: "1980-01-01 17:00:00",
                  email: "julia.parmenter@gmail.com",
                  password: "juliaward",
                  password_confirmation: "juliaward",
                  terms_of_service: true,
                  bio: "Julia Ward is a bootmaker in Austin, Texas. After a lengthy apprenticeship under legendary bootmaker, Lee Miller, Julia Ward has gone out on her own making boots and other leather goods. She is also a teacher of leathercraft and other fiber arts as an adjunct faculty member at the Griffin School.",
                  website: "http://juliawardboots.wordpress.com/"
                  webshop:"",
                  facebook:"",
                  twitter:"",
                )
julia.skip_confirmation!
julia.admin = false
julia.save!(validate: false)

katy = User.new( first_name: "Katy",
                  last_name: "Dougharty",
                  birthday: "1980-01-01 17:00:00",
                  email: "kdglass.studio@gmail.com",
                  password: "katydougharty",
                  password_confirmation: "katydougharty",
                  terms_of_service: true,
                  bio: "Howdy folks!! I'm Katy and I LOVE art. A foundation in drawing, painting, sculpture and education has translated uniquely into my original glass design. I'm excited to be opening my studio doors to new students also in LOVE with art and curious about glass.",
                  website: "http://www.kdougharty.com/"
                  webshop:"",
                  facebook:"",
                  twitter:"",
                )
katy.skip_confirmation!
katy.admin = false
katy.save!(validate: false)

lisa = User.new( first_name: "Lisa",
                  last_name: "Chouinard",
                  birthday: "1980-01-01 17:00:00",
                  email: "lisa@fetosoap.com",
                  password: "lisachouinard",
                  password_confirmation: "lisachouinard",
                  terms_of_service: true,
                  bio: "Speaker at the Handcrafted Soapmakers Guild, Texas Soapmakers Association & Winner of Education and Craft awards from Maker Faire Bay Area. ",
                  website: "http://fetosoap.com/shop"
                  webshop:"",
                  facebook:"",
                  twitter:"",
                )
lisa.skip_confirmation!
lisa.admin = false
lisa.save!(validate: false)

christine = User.new( first_name: "Christine",
                  last_name: "Fail",
                  birthday: "1980-01-01 17:00:00",
                  email: "christine@schatzeleinaustin.com",
                  password: "christinefail",
                  password_confirmation: "christinefail",
                  terms_of_service: true,
                  bio: "With her BFA in studio art, designer Christine Fail's background is firmly rooted in art and design. After 5 years working for two internationally renowned jewelry designers, selling to the country's top retailers, and working directly with customers Christine decided to realize all of her experience and expertise in her own vision. Schatzelein, her retail endeavor, is the fist half of that vision and fail, her line of handmade jewelry, is the second. Each piece is delicately handcrafted in sterling silver and 14K gold-fill in Christine's Austin Texas studio. Christine employs classic metalsmithing technique such as hand forging to form and shape delicate wire. Forging gives wire strength, resiliency, and a soft organic texture that allows the hand of the artist to be present in each piece. Fail jewelry is intentionally lightweight, fluid, and wearable.",
                  website: "https://www.failjewelry.com"
                  webshop:"https://www.schatzeleinaustin.com",
                  facebook:"",
                  twitter:"",
                )
christine.skip_confirmation!
christine.admin = false
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
jeannie.admin = false
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
maura.admin = false
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
caroline.admin = false
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
callen.admin = false
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
elizabeth.admin = false
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
ann.admin = false
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
anna.admin = false
anna.save!(validate: false)

adrienne = User.new( first_name: "Adrienne",
                  last_name: "Butler",
                  birthday: "1980-01-01 17:00:00",
                  email: "niceisdifferent@gmail.com",
                  password: "adriennebutler",
                  password_confirmation: "adriennebutler",
                  terms_of_service: true,
                  bio: "I have been baking at my mother's knee since before I could see the top of the counter. I took this passion with me through life and continued my education at Le Cordon Bleu College of Culinary Arts. Even though I have my degree in savory food, sweets were what captured my heart. Since 2010, I have been making delicious sweets that range from simply sweet to decadently delicious.",
                  website: "http://www.likehoneybakery.com/"
                  webshop:"",
                  facebook:"https://www.facebook.com/likehoneybakery",
                  twitter:"",
                )
adrienne.skip_confirmation!
adrienne.admin = false
adrienne.save!(validate: false)

jessica = User.new( first_name: "Jessica",
                  last_name: "Tata",
                  birthday: "1980-01-01 17:00:00",
                  email: "jessica@sonofasailorjewelry.com",
                  password: "jessicatata",
                  password_confirmation: "jessicatata",
                  terms_of_service: true,
                  bio: "Billy and Jessica revel in playful creation and collaboration. Billy is a graphic designer by trade, but has made stops along the way in the Navy, the oil fields of West Texas, and pilgrimages around the world. Jessica fancies herself a creative marketing professional with a background in art galleries and museums. Our process is very collaborative, as each new piece that we create is a combination of our ideas and experiences. We like to think outside of the box about how materials can be used, and are interested in innovating in playful, exciting ways. We currently have three Production Assistants that you will be working closely with, and the environment in the studio is very lighthearted. While we all have a lot of work to get done, we can often be found doing it to a soundtrack of cheesy pop music. We think it's just as important to have a good time at work as it is to work hard and work well.",
                  website: "http://www.sonofasailorjewelry.com/"
                  webshop:"",
                  facebook:"http://www.facebook/hitheresos",
                  twitter:"",
                )
jessica.skip_confirmation!
jessica.admin = false
jessica.save!(validate: false)

madelyn = User.new( first_name: "Madelyn",
                  last_name: "Thompson",
                  birthday: "1980-01-01 17:00:00",
                  email: "thompson.madelyn@gmail.com",
                  password: "madelynthompson",
                  password_confirmation: "madelynthompson",
                  terms_of_service: true,
                  bio: "I have been baking at my mother's knee since before I could see the top of the counter. I took this passion with me through life and continued my education at Le Cordon Bleu College of Culinary Arts. Even though I have my degree in savory food, sweets were what captured my heart. Since 2010, I have been making delicious sweets that range from simply sweet to decadently delicious.",
                  website: "http://www.likehoneybakery.com/"
                  webshop:"",
                  facebook:"https://www.facebook.com/likehoneybakery",
                  twitter:"",
                )
madelyn.skip_confirmation!
madelyn.admin = false
madelyn.save!(validate: false)

tahila = User.new( first_name: "Tahila",
                  last_name: "Mintz",
                  birthday: "1980-01-01 17:00:00",
                  email: "totahila@gmail.com",
                  password: "tahilamintz",
                  password_confirmation: "tahilamintz",
                  terms_of_service: true,
                  bio: "Tahila Shireem Chavez Mintz is an Austin based photographer. She works nationally and internationally, focusing predominately on culture, women, and indigenous traditions. Her work is lens, collage and bead based. She received her MFA from the University of Texas at Austin, and studied at Filmova a televizni fakulta akademie Prague, Czech republic. ",
                  website: "http://www.shireemimaging.com/"
                  webshop:"",
                  facebook:"",
                  twitter:"",
                )
tahila.skip_confirmation!
tahila.admin = false
tahila.save!(validate: false)

teruko = User.new( first_name: "Teruko",
                  last_name: "Nimura",
                  birthday: "1980-01-01 17:00:00",
                  email: "terukonimura@gmail.com",
                  password: "terukonimura",
                  password_confirmation: "terukonimura",
                  terms_of_service: true,
                  bio: "Teruko Nimura is an Austin based artist who creates mixed media installations and sculptures exploring ideas of collective efforts, Asian customs, and personal history using ceramics, plaster, fabric, paper, wax, wood, and other materials.",
                  website: "http://www.terukonimura.net/"
                  webshop:"",
                  facebook:"",
                  twitter:"",
                )
teruko.skip_confirmation!
teruko.admin = false
teruko.save!(validate: false)

melissa = User.new( first_name: "Melissa",
                  last_name: "Chapman",
                  birthday: "1980-01-01 17:00:00",
                  email: "melissalynnchapman@gmail.com",
                  password: "melissachapman",
                  password_confirmation: "melissachapman",
                  terms_of_service: true,
                  bio: "A recent transplant hailing from Oregon but originally from Georgia (this is not my first southern rodeo), I moved to Texas in mid-August to attend school at the Austin Center for Design. My love for jewelry making dates back to middle school days when I would spend hours and hours making precious beaded creations on my bedroom floor. While living in Portland, my love took a turn for the serious and I began first selling on Etsy and then most recently on Fab.com. We are also in the process of setting up wholesale accounts in stores and looking to grow in this way. The business is growing in lots of interesting ways and remains open to grow in areas that make sense to me. If an apprentice sees this and is excited to explore a particular aspect of the design or business, I remain open to considering all proposals!",
                  website: "http://www.stoneandsmith.com"
                  webshop:"http://www.etsy.com/shop/stoneandsmith",
                  facebook:"",
                  twitter:"",
                )
melissa.skip_confirmation!
melissa.admin = false
melissa.save!(validate: false)

first_workshop = lee.workshops.create!(              "host_firstname"=>"Lee",
                                                        "host_lastname"=>"Webster",
                                                        "host_business"=>"",
                                                        "topic"=>"16mm Direct Animation",
                                                        "description"=>"Join Austin filmmaker, Lee Webster to make a collaborative film. We will draw, paint, etch and collage directly on 16mm film to create beautiful and rhythmic animations. Cameraless, or direct, animation is the practice of applying materials directly to clear 16mm leader or developed film. The result is gorgeous, abstract animations that are filled with surprising life and movement. We will use found objects from nature: leaves, feathers, and insect wings, as well as transparencies, lighting gels, film negatives, inks, stamps, and more to manipulate our film. In the weeks after the workshop, Lee will scan in the film and send each class member a digital copy of the beautiful, finished work. ",
                                                        "skill_list"=>"'splicing film','direct animation'",
                                                        "tool_list"=>"'16mm film','transparencies','ink','stamps','found objects','splicers','light box','projector'",
                                                        "requirement_list"=>"",
                                                        "other_needs"=>"",
                                                        "age_min"=>"10", "age_max"=>"100",
                                                        "registration_min"=>"2",
                                                        "registration_max"=>"12",
                                                        "begins_at"=>"09/22/2013",
                                                        "begins_at_time"=>"10:00 AM",
                                                        "ends_at_time"=>"03:00 PM",
                                                        "datetime_tba"=>"1",
                                                        "location_address"=>"1309 Chestnut Ave.",
                                                        "location_address2"=>"",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78702",
                                                        "location_private"=>"0",
                                                        "location_nbrhood"=>"East Austin",
                                                        "price"=>"45",
                                                        "ends_at"=>"09/17/2013",
                                                        "payment_options"=>"Paypal",
                                                        "paypal_email"=>"lee.kerby.webster@gmail.com",
                                                        "sendcheck_address"=>"",
                                                        "sendcheck_address2"=>"",
                                                        "sendcheck_city"=>"",
                                                        "sendcheck_state"=>"",
                                                        "sendcheck_zip"=>"",
                                                        "respect_my_style"=>"0",
                                                        "permission"=>"1"
                                                      )

first_workshop = stacey.workshops.create!(              "host_firstname"=>"Stacey",
                                                        "host_lastname"=>"Blackman",
                                                        "host_business"=>"Schoolhouse Austin",
                                                        "topic"=>"DIY Printmaking",
                                                        "description"=>"Do you love art and want to learn a new form of generating multiples of your favorite images? This 2 1/2 hour workshop is project based and designed to introduce students to new forms of printmaking that can be reproduced at home. Students will learn the basics of printmaking from creating an original plate to producing a clean print.",
                                                        "skill_list"=>"'printmaking'",
                                                        "tool_list"=>"'water based printing inks','brayers','paper','fabric'",
                                                        "requirement_list"=>"",
                                                        "other_needs"=>"",
                                                        "age_min"=>"16", "age_max"=>"100",
                                                        "registration_min"=>"2",
                                                        "registration_max"=>"12",
                                                        "begins_at"=>"09/01/2013",
                                                        "begins_at_time"=>"10:00 AM",
                                                        "ends_at_time"=>"12:30 PM",
                                                        "datetime_tba"=>"1",
                                                        "location_address"=>"1309 Chestnut Ave.",
                                                        "location_address2"=>"",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78702",
                                                        "location_private"=>"0",
                                                        "location_nbrhood"=>"Chestnut",
                                                        "price"=>"45",
                                                        "ends_at"=>"08/29/2013",
                                                        "payment_options"=>"Paypal",
                                                        "paypal_email"=>"schoolhouseaustin@gmail.com",
                                                        "sendcheck_address"=>"",
                                                        "sendcheck_address2"=>"",
                                                        "sendcheck_city"=>"",
                                                        "sendcheck_state"=>"",
                                                        "sendcheck_zip"=>"",
                                                        "respect_my_style"=>"0",
                                                        "permission"=>"1"
                                                      )

first_workshop = leah.workshops.create!(              "host_firstname"=>"Leah",
                                                        "host_lastname"=>"Overstreet",
                                                        "host_business"=>"",
                                                        "topic"=>"Portrait Photography",
                                                        "description"=>"In this 3.5 hour workshop students will learn the basics of making great portraits. We will cover studio portrait lighting, including Rembrandt lighting. We will explore the elements of composition and creating environmental portraits with natural and strobe light.",
                                                        "skill_list"=>"'photography','lighting','composition'",
                                                        "tool_list"=>"'digital camera','strobe','flash drives','reflectors'",
                                                        "requirement_list"=>"",
                                                        "other_needs"=>"",
                                                        "age_min"=>"14", "age_max"=>"100",
                                                        "registration_min"=>"2",
                                                        "registration_max"=>"12",
                                                        "begins_at"=>"09/15/2013",
                                                        "begins_at_time"=>"10:00 AM",
                                                        "ends_at_time"=>"01:00 PM",
                                                        "datetime_tba"=>"1",
                                                        "location_address"=>"1309 Chestnut Ave.",
                                                        "location_address2"=>"",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78702",
                                                        "location_private"=>"0",
                                                        "location_nbrhood"=>"Chestnut",
                                                        "price"=>"54",
                                                        "ends_at"=>"09/10/2013",
                                                        "payment_options"=>"Paypal",
                                                        "paypal_email"=>"leahoverstreet@gmail.com",
                                                        "sendcheck_address"=>"",
                                                        "sendcheck_address2"=>"",
                                                        "sendcheck_city"=>"",
                                                        "sendcheck_state"=>"",
                                                        "sendcheck_zip"=>"",
                                                        "respect_my_style"=>"0",
                                                        "permission"=>"1"
                                                      )

first_workshop = natalie.workshops.create!(              "host_firstname"=>"Natalie",
                                                        "host_lastname"=>"Davis",
                                                        "host_business"=>"Canoe",
                                                        "topic"=>"Leather Workshop with Canoe",
                                                        "description"=>" Join Natalie Davis of Canoe and Feliz to experience an introduction to leatherworking, using your new skills to tool a personalized leather keychain. You will learn the basics of leatherwork: selecting the right leather weight for different design projects, using tools to stamp leather, how to case leather, and basic construction with rivets. Natalie will share her experience as a member of the Longhorn Trail Leather Guild and guide you with resources to continue exploring leathercraft. Leave the workshop with a fabulous leather keychain.",
                                                        "skill_list"=>"'leathermaking','leather stamping','leather tooling'",
                                                        "tool_list"=>"'leather shears','tooling knives','irons','grommets','hammer'",
                                                        "requirement_list"=>"",
                                                        "other_needs"=>"",
                                                        "age_min"=>"16", "age_max"=>"99",
                                                        "registration_min"=>"4",
                                                        "registration_max"=>"12",
                                                        "begins_at"=>"10/01/2013",
                                                        "begins_at_time"=>"10:00 AM",
                                                        "ends_at_time"=>"01:30 PM",
                                                        "datetime_tba"=>"1",
                                                        "location_address"=>"1309 Chestnut Ave.",
                                                        "location_address2"=>"",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78702",
                                                        "location_private"=>"0",
                                                        "location_nbrhood"=>"Chestnut",
                                                        "price"=>"65",
                                                        "ends_at"=>"09/28/2013",
                                                        "payment_options"=>"Paypal",
                                                        "paypal_email"=>"natalie@canoegoods.com",
                                                        "sendcheck_address"=>"",
                                                        "sendcheck_address2"=>"",
                                                        "sendcheck_city"=>"",
                                                        "sendcheck_state"=>"",
                                                        "sendcheck_zip"=>"",
                                                        "respect_my_style"=>"0",
                                                        "permission"=>"1"
                                                      )



first_workshop = jodi.workshops.create!(              "host_firstname"=>"Jodi",
                                                        "host_lastname"=>"Brownstein",
                                                        "host_business"=>"",
                                                        "topic"=>"Making Awesome Things With Metal",
                                                        "description"=>"I make pieces like this for myself as a reminder of my path, what I am seeking in life, or just to remember what matters. The physicality of shaping, hammering, stamping my intention into the metal makes my final product that much more meaningful. Getting to share this process with others is so very worthwhile. In this workshop, I will lead a silversmithing project, wherein attendees will design and create a dog tag styled pendant. We will saw out simple shapes, learn how to stamp, texture, file, sand, and if desired, oxidize the pieces, which will then be hung on chain, leather, or (possibly) beads to be worn close to the heart. Creativity, love, heartfelt moments, and play are most certainly required. ",
                                                        "skill_list"=>"'jewelry','metal fabrication'",
                                                        "tool_list"=>"'jewelry hammers','drill press','flex shaft','bench pins','rolling mill'",
                                                        "requirement_list"=>"",
                                                        "other_needs"=>"",
                                                        "age_min"=>"19", "age_max"=>"99",
                                                        "registration_min"=>"4",
                                                        "registration_max"=>"12",
                                                        "begins_at"=>"10/10/2013",
                                                        "begins_at_time"=>"10:00 AM",
                                                        "ends_at_time"=>"02:00 PM",
                                                        "datetime_tba"=>"1",
                                                        "location_address"=>"1309 Chestnut Ave.",
                                                        "location_address2"=>"",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78702",
                                                        "location_private"=>"0",
                                                        "location_nbrhood"=>"Chestnut",
                                                        "price"=>"180",
                                                        "ends_at"=>"10/02/2013",
                                                        "payment_options"=>"Paypal",
                                                        "paypal_email"=>"jodi@jodiraedesigns.com",
                                                        "sendcheck_address"=>"",
                                                        "sendcheck_address2"=>"",
                                                        "sendcheck_city"=>"",
                                                        "sendcheck_state"=>"",
                                                        "sendcheck_zip"=>"",
                                                        "respect_my_style"=>"0",
                                                        "permission"=>"1"
                                                      )



first_workshop = jennie.workshops.create!(              "host_firstname"=>"Jennie",
                                                        "host_lastname"=>"Tudor Gray",
                                                        "host_business"=>"",
                                                        "topic"=>"Altered Books Workshop",
                                                        "description"=>"Learn how to create your own unique Altered book artwork with upcycled vintage books from the 1890's to 1980's, miscellaneous ephemera, lost and found photographs, found objects, and other mixed media including drawing, painting, and printmaking. Class will cover a variety of materials and techniques in both 2D and 3D formats. Materials provided but feel free to bring any of your own mementos to incorporate into your artwork as well. ",
                                                        "skill_list"=>"'drawing','mixed media','painting','printmaking'",
                                                        "tool_list"=>"'vintage books','miscellaneous ephemera','old photographs','found objects'",
                                                        "requirement_list"=>"",
                                                        "other_needs"=>"",
                                                        "age_min"=>"11", "age_max"=>"99",
                                                        "registration_min"=>"3",
                                                        "registration_max"=>"12",
                                                        "begins_at"=>"10/20/2013",
                                                        "begins_at_time"=>"10:00 AM",
                                                        "ends_at_time"=>"02:00 PM",
                                                        "datetime_tba"=>"1",
                                                        "location_address"=>"1309 Chestnut Ave.",
                                                        "location_address2"=>"",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78702",
                                                        "location_private"=>"0",
                                                        "location_nbrhood"=>"Chestnut",
                                                        "price"=>"54",
                                                        "ends_at"=>"10/15/2013",
                                                        "payment_options"=>"Paypal",
                                                        "paypal_email"=>"ms.jennie.gray@gmail.com",
                                                        "sendcheck_address"=>"",
                                                        "sendcheck_address2"=>"",
                                                        "sendcheck_city"=>"",
                                                        "sendcheck_state"=>"",
                                                        "sendcheck_zip"=>"",
                                                        "respect_my_style"=>"0",
                                                        "permission"=>"1"
                                                      )



first_workshop = julia.workshops.create!(              "host_firstname"=>"Julia",
                                                        "host_lastname"=>"Ward",
                                                        "host_business"=>"",
                                                        "topic"=>"Sandalmaking",
                                                        "description"=>"We'll be learning the techniques for making leather sandals.",
                                                        "skill_list"=>"'leathermaking','leatherworking'",
                                                        "tool_list"=>"'hammers','leather'",
                                                        "requirement_list"=>"",
                                                        "other_needs"=>"",
                                                        "age_min"=>"16", "age_max"=>"99",
                                                        "registration_min"=>"3",
                                                        "registration_max"=>"12",
                                                        "begins_at"=>"10/30/2013",
                                                        "begins_at_time"=>"10:00 AM",
                                                        "ends_at_time"=>"04:00 PM",
                                                        "datetime_tba"=>"1",
                                                        "location_address"=>"1309 Chestnut Ave.",
                                                        "location_address2"=>"",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78702",
                                                        "location_private"=>"0",
                                                        "location_nbrhood"=>"Chestnut",
                                                        "price"=>"98",
                                                        "ends_at"=>"10/25/2013",
                                                        "payment_options"=>"Paypal",
                                                        "paypal_email"=>"julia.parmenter@gmail.com",
                                                        "sendcheck_address"=>"",
                                                        "sendcheck_address2"=>"",
                                                        "sendcheck_city"=>"",
                                                        "sendcheck_state"=>"",
                                                        "sendcheck_zip"=>"",
                                                        "respect_my_style"=>"0",
                                                        "permission"=>"1"
                                                      )



first_workshop = katy.workshops.create!(              "host_firstname"=>"Katy",
                                                        "host_lastname"=>"Dougharty",
                                                        "host_business"=>"KDGlass",
                                                        "topic"=>"Stained Glass Design",
                                                        "description"=>"Cut, grind, foil, solder, frame: The five foundational steps to creating your own stained glass panel (using the copper foil method) will be covered in this course. This is a class for the beginning beginner that teachers patience, dexterity, accuracy and color theory. By the end of our workshop, you'll have your own 'Window Pendant' to hang proudly at home, or give as a hand-crafted gift.",
                                                        "skill_list"=>"'stained glass','grinding','cutting','soldering'",
                                                        "tool_list"=>"'glass cutter','running pliers','diamond bit grinder','soldering iron'",
                                                        "requirement_list"=>"",
                                                        "other_needs"=>"",
                                                        "age_min"=>"15", "age_max"=>"99",
                                                        "registration_min"=>"3",
                                                        "registration_max"=>"8",
                                                        "begins_at"=>"11/05/2013",
                                                        "begins_at_time"=>"10:00 AM",
                                                        "ends_at_time"=>"05:00 PM",
                                                        "datetime_tba"=>"1",
                                                        "location_address"=>"1309 Chestnut Ave.",
                                                        "location_address2"=>"",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78702",
                                                        "location_private"=>"0",
                                                        "location_nbrhood"=>"Chestnut",
                                                        "price"=>"58",
                                                        "ends_at"=>"11/01/2013",
                                                        "payment_options"=>"Paypal",
                                                        "paypal_email"=>"kdglass.studio@gmail.com",
                                                        "sendcheck_address"=>"",
                                                        "sendcheck_address2"=>"",
                                                        "sendcheck_city"=>"",
                                                        "sendcheck_state"=>"",
                                                        "sendcheck_zip"=>"",
                                                        "respect_my_style"=>"0",
                                                        "permission"=>"1"
                                                      )



first_workshop = lisa.workshops.create!(              "host_firstname"=>"Lisa",
                                                        "host_lastname"=>"Chouinard",
                                                        "host_business"=>"Feto Soap",
                                                        "topic"=>"Learn to Make Soap",
                                                        "description"=>"Learn to make soap with Lisa and leave with a bar of your own.",
                                                        "skill_list"=>"'soapmaking'",
                                                        "tool_list"=>"'soap'",
                                                        "requirement_list"=>"",
                                                        "other_needs"=>"Parents should accompany their children",
                                                        "age_min"=>"4", "age_max"=>"16",
                                                        "registration_min"=>"4",
                                                        "registration_max"=>"8",
                                                        "begins_at"=>"11/15/2013",
                                                        "begins_at_time"=>"10:00 AM",
                                                        "ends_at_time"=>"02:00 PM",
                                                        "datetime_tba"=>"1",
                                                        "location_address"=>"1309 Chestnut Ave.",
                                                        "location_address2"=>"",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78702",
                                                        "location_private"=>"0",
                                                        "location_nbrhood"=>"Chestnut",
                                                        "price"=>"30",
                                                        "ends_at"=>"11/10/2013",
                                                        "payment_options"=>"Paypal",
                                                        "paypal_email"=>"lisa@fetosoap.com",
                                                        "sendcheck_address"=>"",
                                                        "sendcheck_address2"=>"",
                                                        "sendcheck_city"=>"",
                                                        "sendcheck_state"=>"",
                                                        "sendcheck_zip"=>"",
                                                        "respect_my_style"=>"0",
                                                        "permission"=>"1"
                                                      )



first_workshop = christine.workshops.create!(           "host_firstname"=>"Christine",
                                                        "host_lastname"=>"Fail",
                                                        "host_business"=>"Fail Jewelry",
                                                        "topic"=>"Basics of setting up an Etsy shop",
                                                        "description"=>"Learn how to put together a cohesive collection, price, photograph, and market it through Etsy and similar online platforms.",
                                                        "skill_list"=>"'product photography','business','marketing'",
                                                        "tool_list"=>"'Etsy', 'Paypal', 'digital camera', 'iPhoto'",
                                                        "requirement_list"=>"",
                                                        "other_needs"=>"Bring your laptop, or paper for taking notes!",
                                                        "age_min"=>"16", "age_max"=>"19",
                                                        "registration_min"=>"4",
                                                        "registration_max"=>"12",
                                                        "begins_at"=>"11/25/2013",
                                                        "begins_at_time"=>"10:00 AM",
                                                        "ends_at_time"=>"03:00 PM",
                                                        "datetime_tba"=>"1",
                                                        "location_address"=>"1309 Chestnut Ave.",
                                                        "location_address2"=>"",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78702",
                                                        "location_private"=>"0",
                                                        "location_nbrhood"=>"Chestnut",
                                                        "price"=>"30",
                                                        "ends_at"=>"11/20/2013",
                                                        "payment_options"=>"Paypal",
                                                        "paypal_email"=>"christine@schatzeleinaustin.com",
                                                        "sendcheck_address"=>"",
                                                        "sendcheck_address2"=>"",
                                                        "sendcheck_city"=>"",
                                                        "sendcheck_state"=>"",
                                                        "sendcheck_zip"=>"",
                                                        "respect_my_style"=>"0",
                                                        "permission"=>"1"
                                                      )




# first_apprenticeship = artist.apprenticeships.create!(  "host_firstname"=>"Martha",
#                                                         "host_lastname"=>"Smith",
#                                                         "host_business"=>"",
#                                                         "kind" => "event",
#                                                         "bio"=>"Vivamus ut accumsan nulla. Maecenas consequat vestibulum dapibus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at purus urna. Sed adipiscing risus non elit molestie eget tempus massa porta. Ut in ligula elit. ",
#                                                         "website"=>"msdesigns.com",
#                                                         "webshop"=>"shop.msdesigns.com",
#                                                         "facebook"=>"marthasmith",
#                                                         "twitter"=>"martha_smith",
#                                                         "topic"=>"Sculpture Creation",
#                                                         "kind"=>"Production",
#                                                         "description"=>"Quisque in ligula id arcu fringilla gravida a vel purus. Etiam tempus hendrerit augue, vel luctus metus egestas quis. Morbi sit amet felis non purus rutrum adipiscing. Proin aliquet sapien at tellus hendrerit eget cursus orci cursus. Donec turpis sem, ullamcorper eget sodales non, vulputate nec dolor. Proin tortor metus, fringilla eget tristique eu, gravida nec mi. Quisque vitae quam magna, hendrerit sollicitudin metus. Nulla quis purus justo, eget porttitor turpis. Donec fringilla ullamcorper risus vitae lobortis. Sed vitae lacus neque, adipiscing eleifend nisl. Phasellus faucibus erat eget justo luctus consectetur. Curabitur sed venenatis nisi. Suspendisse potenti. ",
#                                                         "skill_list"=>"'Paper Sculpting','Sketching','circular sander'",
#                                                         "tool_list"=>"'Adhesive','exacto blades','sand paper'",
#                                                         "requirement_list"=>"'some comfort with electric tools and blades'",
#                                                         "other_needs"=>"Have their own transportation",
#                                                         "age_min"=>"16",
#                                                         "age_max"=>"25",
#                                                         "registration_max"=>"2",
#                                                         "begins_at"=>"08/01/2013",
#                                                         "ends_at"=>"12/01/2013",
#                                                         "datetime_tba"=>"0",
#                                                         "hours"=>"4",
#                                                         "hours_per"=>"week",
#                                                         "location_address"=>"615 W Johanna St",
#                                                         "location_address2"=>"",
#                                                         "location_city"=>"Austin",
#                                                         "location_state"=>"TX",
#                                                         "location_zipcode"=>"78704",
#                                                         "location_private"=>"1",
#                                                         "location_nbrhood"=>"Bouldin Creek",
#                                                         "location_varies"=>"0",
#                                                         "respect_my_style"=>"1",
#                                                         "stripe_card_token"=>"",
#                                                         "permission"=>"1",
#                                                         "availability"=>"M-F, 3-7pm. Flexible on weekend days."
#                                                      )
# second_apprenticeship = artist.apprenticeships.create!(  "host_firstname"=>"Martha",
#                                                         "host_lastname"=>"Smith",
#                                                         "host_business"=>"MS Designs",
#                                                         "kind" => "production",
#                                                         "bio"=>"Vivamus ut accumsan nulla. Maecenas consequat vestibulum dapibus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at purus urna. Sed adipiscing risus non elit molestie eget tempus massa porta. Ut in ligula elit. ",
#                                                         "website"=>"msdesigns.com",
#                                                         "webshop"=>"shop.msdesigns.com",
#                                                         "facebook"=>"marthasmith",
#                                                         "twitter"=>"martha_smith",
#                                                         "topic"=>"Kids Craft",
#                                                         "kind"=>"Ongoing",
#                                                         "description"=>"Quisque in ligula id arcu fringilla gravida a vel purus. Etiam tempus hendrerit augue, vel luctus metus egestas quis. Morbi sit amet felis non purus rutrum adipiscing. Proin aliquet sapien at tellus hendrerit eget cursus orci cursus. Donec turpis sem, ullamcorper eget sodales non, vulputate nec dolor. Proin tortor metus, fringilla eget tristique eu, gravida nec mi. Quisque vitae quam magna, hendrerit sollicitudin metus. Nulla quis purus justo, eget porttitor turpis. Donec fringilla ullamcorper risus vitae lobortis. Sed vitae lacus neque, adipiscing eleifend nisl. Phasellus faucibus erat eget justo luctus consectetur. Curabitur sed venenatis nisi. Suspendisse potenti. ",
#                                                         "skill_list"=>"'Paper Sculpting','Sketching','circular sander'",
#                                                         "tool_list"=>"'Adhesive','exacto blades','sand paper'",
#                                                         "requirement_list"=>"'some comfort with electric tools and blades'",
#                                                         "other_needs"=>"Have their own transportation",
#                                                         "age_min"=>"3",
#                                                         "age_max"=>"12",
#                                                         "registration_max"=>"5",
#                                                         "begins_at"=>"09/01/2013",
#                                                         "ends_at"=>"12/01/2013",
#                                                         "datetime_tba"=>"0",
#                                                         "hours"=>"4",
#                                                         "hours_per"=>"week",
#                                                         "location_address"=>"615 W Johanna St",
#                                                         "location_address2"=>"",
#                                                         "location_city"=>"Austin",
#                                                         "location_state"=>"TX",
#                                                         "location_zipcode"=>"78704",
#                                                         "location_private"=>"1",
#                                                         "location_nbrhood"=>"Cherrywood",
#                                                         "location_varies"=>"0",
#                                                         "respect_my_style"=>"1",
#                                                         "stripe_card_token"=>"",
#                                                         "permission"=>"1",
#                                                         "availability"=>"Mondays, Wednesdays, and Thursdays, in the afternoon. Usually free on weekend days."
#                                                      )
# third_apprenticeship = artist.apprenticeships.create!(  "host_firstname"=>"Martha",
#                                                         "host_lastname"=>"Smith",
#                                                         "host_business"=>"MS Designs",
#                                                         "kind" => "ongoing",
#                                                         "bio"=>"Vivamus ut accumsan nulla. Maecenas consequat vestibulum dapibus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at purus urna. Sed adipiscing risus non elit molestie eget tempus massa porta. Ut in ligula elit. ",
#                                                         "website"=>"msdesigns.com",
#                                                         "webshop"=>"shop.msdesigns.com",
#                                                         "facebook"=>"marthasmith",
#                                                         "twitter"=>"martha_smith",
#                                                         "topic"=>"Teenishness",
#                                                         "kind"=>"Event",
#                                                         "description"=>"Quisque in ligula id arcu fringilla gravida a vel purus. Etiam tempus hendrerit augue, vel luctus metus egestas quis. Morbi sit amet felis non purus rutrum adipiscing. Proin aliquet sapien at tellus hendrerit eget cursus orci cursus. Donec turpis sem, ullamcorper eget sodales non, vulputate nec dolor. Proin tortor metus, fringilla eget tristique eu, gravida nec mi. Quisque vitae quam magna, hendrerit sollicitudin metus. Nulla quis purus justo, eget porttitor turpis. Donec fringilla ullamcorper risus vitae lobortis. Sed vitae lacus neque, adipiscing eleifend nisl. Phasellus faucibus erat eget justo luctus consectetur. Curabitur sed venenatis nisi. Suspendisse potenti. ",
#                                                         "skill_list"=>"'Paper Sculpting','Sketching','circular sander'",
#                                                         "tool_list"=>"'Adhesive','exacto blades','sand paper'",
#                                                         "requirement_list"=>"'some comfort with electric tools and blades'",
#                                                         "other_needs"=>"Have their own transportation",
#                                                         "age_min"=>"13",
#                                                         "age_max"=>"19",
#                                                         "registration_max"=>"4",
#                                                         "begins_at"=>"09/01/2013",
#                                                         "ends_at"=>"12/01/2013",
#                                                         "datetime_tba"=>"0",
#                                                         "hours"=>"4",
#                                                         "hours_per"=>"week",
#                                                         "location_address"=>"615 W Johanna St",
#                                                         "location_address2"=>"",
#                                                         "location_city"=>"Austin",
#                                                         "location_state"=>"TX",
#                                                         "location_zipcode"=>"78704",
#                                                         "location_private"=>"1",
#                                                         "location_nbrhood"=>"Eanes",
#                                                         "location_varies"=>"0",
#                                                         "respect_my_style"=>"1",
#                                                         "stripe_card_token"=>"",
#                                                         "permission"=>"1",
#                                                         "availability"=>"M-F, 3-7pm. Flexible on weekend days."
#                                                      )
# fourth_apprenticeship = artist.apprenticeships.create!(  "host_firstname"=>"Martha",
#                                                         "host_lastname"=>"Smith",
#                                                         "host_business"=>"MS Designs",
#                                                         "kind" => "event",
#                                                         "bio"=>"Vivamus ut accumsan nulla. Maecenas consequat vestibulum dapibus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at purus urna. Sed adipiscing risus non elit molestie eget tempus massa porta. Ut in ligula elit. ",
#                                                         "website"=>"msdesigns.com",
#                                                         "webshop"=>"shop.msdesigns.com",
#                                                         "facebook"=>"marthasmith",
#                                                         "twitter"=>"martha_smith",
#                                                         "topic"=>"All Ages",
#                                                         "kind"=>"Event",
#                                                         "description"=>"Quisque in ligula id arcu fringilla gravida a vel purus. Etiam tempus hendrerit augue, vel luctus metus egestas quis. Morbi sit amet felis non purus rutrum adipiscing. Proin aliquet sapien at tellus hendrerit eget cursus orci cursus. Donec turpis sem, ullamcorper eget sodales non, vulputate nec dolor. Proin tortor metus, fringilla eget tristique eu, gravida nec mi. Quisque vitae quam magna, hendrerit sollicitudin metus. Nulla quis purus justo, eget porttitor turpis. Donec fringilla ullamcorper risus vitae lobortis. Sed vitae lacus neque, adipiscing eleifend nisl. Phasellus faucibus erat eget justo luctus consectetur. Curabitur sed venenatis nisi. Suspendisse potenti. ",
#                                                         "skill_list"=>"'Paper Sculpting','Sketching','circular sander'",
#                                                         "tool_list"=>"'Adhesive','exacto blades','sand paper'",
#                                                         "requirement_list"=>"'some comfort with electric tools and blades'",
#                                                         "other_needs"=>"Have their own transportation",
#                                                         "age_min"=>"1",
#                                                         "age_max"=>"100",
#                                                         "registration_max"=>"13",
#                                                         "begins_at"=>"09/01/2013",
#                                                         "ends_at"=>"12/01/2013",
#                                                         "datetime_tba"=>"0",
#                                                         "hours"=>"4",
#                                                         "hours_per"=>"week",
#                                                         "location_address"=>"615 W Johanna St",
#                                                         "location_address2"=>"",
#                                                         "location_city"=>"Austin",
#                                                         "location_state"=>"TX",
#                                                         "location_zipcode"=>"78704",
#                                                         "location_private"=>"1",
#                                                         "location_nbrhood"=>"Spicewood",
#                                                         "location_varies"=>"0",
#                                                         "respect_my_style"=>"1",
#                                                         "stripe_card_token"=>"",
#                                                         "permission"=>"1",
#                                                         "availability"=>"M-F, 3-7pm. Flexible on weekend days."
#                                                      )
# fifth_apprenticeship = artist.apprenticeships.create!(  "host_firstname"=>"Martha",
#                                                         "host_lastname"=>"Smith",
#                                                         "host_business"=>"MS Designs",
#                                                         "kind" => "event",
#                                                         "bio"=>"Vivamus ut accumsan nulla. Maecenas consequat vestibulum dapibus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at purus urna. Sed adipiscing risus non elit molestie eget tempus massa porta. Ut in ligula elit. ",
#                                                         "website"=>"msdesigns.com",
#                                                         "webshop"=>"shop.msdesigns.com",
#                                                         "facebook"=>"marthasmith",
#                                                         "twitter"=>"martha_smith",
#                                                         "topic"=>"Come One Come All",
#                                                         "kind"=>"Ongoing",
#                                                         "description"=>"Quisque in ligula id arcu fringilla gravida a vel purus. Etiam tempus hendrerit augue, vel luctus metus egestas quis. Morbi sit amet felis non purus rutrum adipiscing. Proin aliquet sapien at tellus hendrerit eget cursus orci cursus. Donec turpis sem, ullamcorper eget sodales non, vulputate nec dolor. Proin tortor metus, fringilla eget tristique eu, gravida nec mi. Quisque vitae quam magna, hendrerit sollicitudin metus. Nulla quis purus justo, eget porttitor turpis. Donec fringilla ullamcorper risus vitae lobortis. Sed vitae lacus neque, adipiscing eleifend nisl. Phasellus faucibus erat eget justo luctus consectetur. Curabitur sed venenatis nisi. Suspendisse potenti. ",
#                                                         "skill_list"=>"'Paper Sculpting','Sketching','circular sander'",
#                                                         "tool_list"=>"'Adhesive','exacto blades','sand paper'",
#                                                         "requirement_list"=>"'some comfort with electric tools and blades'",
#                                                         "other_needs"=>"Have their own transportation",
#                                                         "age_min"=>"1",
#                                                         "age_max"=>"100",
#                                                         "registration_max"=>"3",
#                                                         "begins_at"=>"09/01/2013",
#                                                         "ends_at"=>"12/01/2013",
#                                                         "datetime_tba"=>"0",
#                                                         "hours"=>"4",
#                                                         "hours_per"=>"week",
#                                                         "location_address"=>"615 W Johanna St",
#                                                         "location_address2"=>"",
#                                                         "location_city"=>"Austin",
#                                                         "location_state"=>"TX",
#                                                         "location_zipcode"=>"78704",
#                                                         "location_private"=>"1",
#                                                         "location_nbrhood"=>"Travis Heights",
#                                                         "location_varies"=>"0",
#                                                         "respect_my_style"=>"1",
#                                                         "stripe_card_token"=>"",
#                                                         "permission"=>"1",
#                                                         "availability"=>"M-F, 3-7pm. Flexible on weekend days."
#                                                      )
# sixth_apprenticeship = artist.apprenticeships.create!(  "host_firstname"=>"Martha",
#                                                         "host_lastname"=>"Smith",
#                                                         "host_business"=>"MS Designs",
#                                                         "kind" => "production",
#                                                         "bio"=>"Vivamus ut accumsan nulla. Maecenas consequat vestibulum dapibus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nulla at purus urna. Sed adipiscing risus non elit molestie eget tempus massa porta. Ut in ligula elit. ",
#                                                         "website"=>"msdesigns.com",
#                                                         "webshop"=>"shop.msdesigns.com",
#                                                         "facebook"=>"marthasmith",
#                                                         "twitter"=>"martha_smith",
#                                                         "topic"=>"Everyone Allowed",
#                                                         "kind"=>"Ongoing",
#                                                         "description"=>"Quisque in ligula id arcu fringilla gravida a vel purus. Etiam tempus hendrerit augue, vel luctus metus egestas quis. Morbi sit amet felis non purus rutrum adipiscing. Proin aliquet sapien at tellus hendrerit eget cursus orci cursus. Donec turpis sem, ullamcorper eget sodales non, vulputate nec dolor. Proin tortor metus, fringilla eget tristique eu, gravida nec mi. Quisque vitae quam magna, hendrerit sollicitudin metus. Nulla quis purus justo, eget porttitor turpis. Donec fringilla ullamcorper risus vitae lobortis. Sed vitae lacus neque, adipiscing eleifend nisl. Phasellus faucibus erat eget justo luctus consectetur. Curabitur sed venenatis nisi. Suspendisse potenti. ",
#                                                         "skill_list"=>"'Paper Sculpting','Sketching','circular sander'",
#                                                         "tool_list"=>"'Adhesive','exacto blades','sand paper'",
#                                                         "requirement_list"=>"'some comfort with electric tools and blades'",
#                                                         "other_needs"=>"Have their own transportation",
#                                                         "age_min"=>"1",
#                                                         "age_max"=>"100",
#                                                         "registration_max"=>"30",
#                                                         "begins_at"=>"09/01/2013",
#                                                         "ends_at"=>"12/01/2013",
#                                                         "datetime_tba"=>"0",
#                                                         "hours"=>"4",
#                                                         "hours_per"=>"week",
#                                                         "location_address"=>"615 W Johanna St",
#                                                         "location_address2"=>"",
#                                                         "location_city"=>"Austin",
#                                                         "location_state"=>"TX",
#                                                         "location_zipcode"=>"78704",
#                                                         "location_private"=>"1",
#                                                         "location_nbrhood"=>"Westlake Hills",
#                                                         "location_varies"=>"0",
#                                                         "respect_my_style"=>"1",
#                                                         "stripe_card_token"=>"",
#                                                         "permission"=>"1",
#                                                         "availability"=>"M-F, 3-7pm. Flexible on weekend days."
#                                                      )
Event.all.each do |event|
  event.generate_title
end


