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

admin = User.new( first_name: "Admin",
                  last_name: "Istrator",
                  birthday: "1980-01-01 17:00:00",
                  email: "admin@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                )
admin.skip_confirmation!
admin.admin = true
admin.save!(validate: false)

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
                  email: "teen@girlsguild.com",
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

xochi = User.new( first_name: "Xochi",
                  last_name: "Solis",
                  birthday: "1980-08-08 17:00:00",
                  email: "xochi@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                )
xochi.skip_confirmation!
xochi.admin = false
xochi.save!(validate: false)

#xochi_gallery = xochi.Gallery.new

nicole = User.new( first_name: "Nicole",
                  last_name: "Anderson",
                  birthday: "1993-01-01 17:00:00",
                  email: "nicole@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                )
nicole.skip_confirmation!
nicole.admin = false
nicole.save!(validate: false)

lee = User.new( first_name: "Lee",
                  last_name: "Webster",
                  birthday: "1980-01-01 17:00:00",
                  email: "lee@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                  bio: "Lee Webster was born in Philadelphia, PA and currently lives and works in Austin, TX. Her practice incorporates film, video, installation and public projects. Her work has been shown at Art House at the Jones Center, Sofa Gallery, Domy Books, and Co-lab in Austin, Sarah Lawrence College in New York, and Danger Danger Gallery in Philadelphia. Her films have been included in screenings at Box 13 in Houston, Portland Oregon Women's Film Festival, Women and Their Work, as part of a special screening for the Texas Biennial and as part of the Fusebox Festival in Austin, TX. Her work as a video designer for theater has won recognition by the Austin Critics Table. She is a working artist, teacher and a founding member of the video art collective, Austin Video Bee.",
                  website: "leewebster.com",
                  webshop: "",
                  facebook: "",
                  twitter: "",
                )
lee.skip_confirmation!
lee.admin = false
lee.save!(validate: false)

stacey = User.new( first_name: "Stacey",
                  last_name: "Blackman",
                  birthday: "1980-01-01 17:00:00",
                  email: "stacey@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                  bio: "Stacey Blackman is an artist educator who founded ScHoolHouse Austin to offer skill based workshops in the fine arts, creative culture and design for both children and adults. She studied at Pratt Institute in Brooklyn and the Aegean Center for Fine Arts in Greece. Stacey believes the practice of creating can bring about a new way of experiencing and engaging the world around us. Create happy!",
                  website: "schoolhouseaustin.com",
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
                  email: "leah@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                  bio: "I began my career working as a photographer for the Smithsonian's National Zoo in D.C. After moving to NYC, I worked in the photo departments of GQ, Vogue, Men's Journal and MTV Networks. These diverse backgrounds of fashion, celebrity, and adventure, helped me become a more thoughtful and creative photographer.",
                  website: "leahoverstreet.com",
                  webshop: "",
                  facebook: "",
                  twitter: "",
                )
leah.skip_confirmation!
leah.admin = false
leah.save!(validate: false)

natalie = User.new( first_name: "Natalie",
                  last_name: "Davis",
                  birthday: "1980-01-01 17:00:00",
                  email: "natalie@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                  bio: "Natalie Davis is a designer, artist, and educator. In 2007 she launched Miss Natalie, a collection of home accessories and kids' goods, featuring best sellers like the heirloom growth chart and wooden apple boxes. Her work has been showcased on Design*Sponge, Apartment Therapy, Sunset, and Whole Living, among other publications. Inspired by her move to Austin, Natalie launched Canoe, a line of hand tooled leather accessories. In 2011 she produced five pop up shops and began blogging at Tool & Tack, which highlights artisans and rebels of all kinds.",
                  website: "canoegoods.com",
                  webshop: "",
                  facebook: "",
                  twitter: "",
                )
natalie.skip_confirmation!
natalie.admin = false
natalie.save!(validate: false)

jodi = User.new( first_name: "Jodi",
                  last_name: "Brownstein",
                  birthday: "1980-01-01 17:00:00",
                  email: "jodi@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                  bio: "I am an artist who has been making and selling my own handcrafted jewelry since the age of 8. My art has become not just my passion, but also my life's work, and I am thrilled to share it with you. I have spent the past few decades honing and developing my own versatile style of jewelry using sterling silver, 18- and 22-karat gold, semiprecious and precious gems, and many different kinds of minerals and stones. I have always been drawn to rare and unique stones in nature, and I pride myself on finding the most strikingly beautiful specimens to use in my pieces.",
                  website: "jodiraedesigns.com",
                  webshop: "",
                  facebook: "",
                  twitter: "",
                )
jodi.skip_confirmation!
jodi.admin = false
jodi.save!(validate: false)

jennie = User.new( first_name: "Jennie",
                  last_name: "Gray",
                  birthday: "1980-01-01 17:00:00",
                  email: "jennie@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                  bio: "Jennie Tudor Gray, named after children's author Tasha Tudor, is an Artist and Arts Educator living in Austin, TX. She graduated magna cum laude from Texas State University with a BFA in Studio Art and All Level Teaching Certification and is passionate about using creative arts education as a method of social change. She enjoys making art out of old books, ephemera, old photos, & found objects.",
                  website: "jennietudorgray.com",
                  webshop: "",
                  facebook: "",
                  twitter: "",
                )
jennie.skip_confirmation!
jennie.admin = false
jennie.save!(validate: false)

julia = User.new( first_name: "Julia",
                  last_name: "Ward",
                  birthday: "1980-01-01 17:00:00",
                  email: "julia@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                  bio: "Julia Ward is a bootmaker in Austin, Texas. After a lengthy apprenticeship under legendary bootmaker, Lee Miller, Julia Ward has gone out on her own making boots and other leather goods. She is also a teacher of leathercraft and other fiber arts as an adjunct faculty member at the Griffin School.",
                  website: "juliawardboots.wordpress.com/",
                  webshop: "",
                  facebook: "",
                  twitter: "",
                )
julia.skip_confirmation!
julia.admin = false
julia.save!(validate: false)

katy = User.new( first_name: "Katy",
                  last_name: "Dougharty",
                  birthday: "1980-01-01 17:00:00",
                  email: "katy@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                  bio: "Howdy folks!! I'm Katy and I LOVE art. A foundation in drawing, painting, sculpture and education has translated uniquely into my original glass design. I'm excited to be opening my studio doors to new students also in LOVE with art and curious about glass.",
                  website: "kdougharty.com",
                  webshop: "",
                  facebook: "",
                  twitter: "",
                )
katy.skip_confirmation!
katy.admin = false
katy.save!(validate: false)

lisa = User.new( first_name: "Lisa",
                  last_name: "Chouinard",
                  birthday: "1980-01-01 17:00:00",
                  email: "lisa@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                  bio: "Speaker at the Handcrafted Soapmakers Guild, Texas Soapmakers Association & Winner of Education and Craft awards from Maker Faire Bay Area.",
                  website: "fetosoap.com/shop",
                  webshop: "",
                  facebook: "",
                  twitter: "",
                )
lisa.skip_confirmation!
lisa.admin = false
lisa.save!(validate: false)

christine = User.new( first_name: "Christine",
                  last_name: "Fail",
                  birthday: "1980-01-01 17:00:00",
                  email: "christine@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                  bio: "With her BFA in studio art, designer Christine Fail's background is firmly rooted in art and design. After 5 years working for two internationally renowned jewelry designers, selling to the country's top retailers, and working directly with customers Christine decided to realize all of her experience and expertise in her own vision. Schatzelein, her retail endeavor, is the fist half of that vision and fail, her line of handmade jewelry, is the second. Each piece is delicately handcrafted in sterling silver and 14K gold-fill in Christine's Austin Texas studio. Christine employs classic metalsmithing technique such as hand forging to form and shape delicate wire. Forging gives wire strength, resiliency, and a soft organic texture that allows the hand of the artist to be present in each piece. Fail jewelry is intentionally lightweight, fluid, and wearable.",
                  website: "failjewelry.com",
                  webshop: "schatzeleinaustin.com",
                  facebook: "",
                  twitter: "",
                )
christine.skip_confirmation!
christine.admin = false
christine.save!(validate: false)

jeannie = User.new( first_name: "Jeannie",
                  last_name: "Vianney",
                  birthday: "1980-01-01 17:00:00",
                  email: "jeannie@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                  bio: "Jeannie Vianney, winner of Texas' Next Top Designer 2011, is a Computer Science graduate turned jewelry designer living in Austin, TX. She launched her first collection in 2005, with online sales and boutiques to quickly follow. Her pieces have been featured in numerous publications such as Lucky Magazine, DailyCandy, Washington Post, and many more. Her signature style of lace cast metal jewelry exude a modern vintage feel.",
                  website: "byjeannie.com",
                  webshop: "",
                  facebook: "ByJeannie",
                  twitter: "byjeannie",
                )
jeannie.skip_confirmation!
jeannie.admin = false
jeannie.save!(validate: false)

maura = User.new( first_name: "Maura",
                  last_name: "Ambrose",
                  birthday: "1980-01-01 17:00:00",
                  email: "maura@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                  bio: "Folk Fibers is the creation of Maura Grace Ambrose. Maura was educated in Textile Design & Fiber Arts at Savannah College of Art and Design. She devoted a few years to traveling, working with preschools, and organic farms. Now she is bringing it all together!
",
                  website: "folkfibers.com",
                  webshop: "mauragraceambrose.etsy.com",
                  facebook: "folkfibers",
                  twitter: "folkfibers",
                )
maura.skip_confirmation!
maura.admin = false
maura.save!(validate: false)

caroline = User.new( first_name: "Caroline",
                  last_name: "Wright",
                  birthday: "1980-01-01 17:00:00",
                  email: "caroline@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                  bio: "Caroline Wright is a painter and a cellist, and finds the disciplines to instruct each other. Wright's paintings are both exuberant and contemplative, merging aspects of music, movement, and landscape. With drippy acrylics and inks on surfaces as varied as rice paper, paper bags, and fabric, Wright uses painting to slow down and connect to the rhythm underlying life. She also enjoys collaborating with musicians, dancers, and filmmakers, to explore how these art forms overlap.",
                  website: "carolinewrightart.com",
                  webshop: "",
                  facebook: "",
                  twitter: "",
                )
caroline.skip_confirmation!
caroline.admin = false
caroline.save!(validate: false)

callen = User.new( first_name: "Callen",
                  last_name: "Thompson",
                  birthday: "1980-01-01 17:00:00",
                  email: "callen@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                  bio: "Callen Thompson is an artist and textile designer living in Austin, Texas. She studied art at Dartmouth College and Cranbrook Academy of Art. Callen was born in Melrose, Florida, a sleepy town with 27 lakes and one stoplight. She was raised in the woods, in a house her parents built by hand. As a sixth-generation Floridian, Callen was taught by her grandmother to always respect the land, especially in a state that cedes often to the interests of development. Her work reflects this love for the land through abstracted desert spaces, mountains, and biomorphic patterning. She aims to visually knit geographies of memory based on human experiences on the land.",
                  website: "callenthompson.com",
                  webshop: "calliehelen.etsy.com",
                  facebook: "CallenThompson",
                  twitter: "CallieHelen",
                )
callen.skip_confirmation!
callen.admin = false
callen.save!(validate: false)

elizabeth = User.new( first_name: "Elizabeth",
                  last_name: "Chiles",
                  birthday: "1980-01-01 17:00:00",
                  email: "elizabeth@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                  bio: "Elizabeth Chiles is a photographer and professor of art at University of Texas at Austin.  She combines elements of landscape to create bodies of photographs that speak to the experience of particular places and times.  Her work was included in Austin Museum of Art's New Art in Austin: 15 to Watch in 2010 and was featured in the 2010 Texas Biennial.",
                  website: "elizabethchiles.com",
                  webshop: "",
                  facebook: "",
                  twitter: "",
                )
elizabeth.skip_confirmation!
elizabeth.admin = false
elizabeth.save!(validate: false)

ann = User.new( first_name: "Ann",
                  last_name: "Armstrong",
                  birthday: "1980-01-01 17:00:00",
                  email: "ann@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                  bio: "Ann Armstrong is an architect, artist, and welder. Her current projects include: ephemeral street art, murals, furniture, and sculptural bike racks.",
                  website: "ann-made.org",
                  webshop: "urbanlandart.org",
                  facebook: "",
                  twitter: "urban_land_art",
                )
ann.skip_confirmation!
ann.admin = false
ann.save!(validate: false)

anna = User.new( first_name: "Anna",
                  last_name: "Gieselman",
                  birthday: "1980-01-01 17:00:00",
                  email: "anna@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                  bio: "Anna Gieselman is a jewelry designer and back yard beekeeper. Her latest line Bee Amour is a fusion of those two passions. All of her work is hand made out of her studio on the east side of Austin.",
                  website: "beeamour.com",
                  webshop: "",
                  facebook: "beeamour",
                  twitter: "rarefactions",
                )
anna.skip_confirmation!
anna.admin = false
anna.save!(validate: false)

adrienne = User.new( first_name: "Adrienne",
                  last_name: "Butler",
                  birthday: "1980-01-01 17:00:00",
                  email: "adrienne@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                  bio: "Adrienne Butler is an artist and teacher living in Austin, TX. She received her BFA in Studio Art/Painting from Texas State University and her MFA in Printmedia from Cranbrook Academy of Art. Adrienne teaches at Texas State University. She makes drawings, paintings,prints, textile work, and wall paintings. Her favorite color is green. Her next favorite color is different green.",
                  website: "niceisdifferent.blogspot.com",
                  webshop: "",
                  facebook: "",
                  twitter: "",
                )
adrienne.skip_confirmation!
adrienne.admin = false
adrienne.save!(validate: false)

jessica = User.new( first_name: "Jessica",
                  last_name: "Tata",
                  birthday: "1980-01-01 17:00:00",
                  email: "jessica@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                  bio: "Billy and Jessica revel in playful creation and collaboration. Billy is a graphic designer by trade, but has made stops along the way in the Navy, the oil fields of West Texas, and pilgrimages around the world. Jessica fancies herself a creative marketing professional with a background in art galleries and museums. Our process is very collaborative, as each new piece that we create is a combination of our ideas and experiences. We like to think outside of the box about how materials can be used, and are interested in innovating in playful, exciting ways. We currently have three Production Assistants that you will be working closely with, and the environment in the studio is very lighthearted. While we all have a lot of work to get done, we can often be found doing it to a soundtrack of cheesy pop music. We think it's just as important to have a good time at work as it is to work hard and work well.",
                  website: "sonofasailorjewelry.com/",
                  webshop: "",
                  facebook: "hitheresos",
                  twitter: "",
                )
jessica.skip_confirmation!
jessica.admin = false
jessica.save!(validate: false)

madelyn = User.new( first_name: "Madelyn",
                  last_name: "Thompson",
                  birthday: "1980-01-01 17:00:00",
                  email: "madelyn@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                  bio: "I have been baking at my mother's knee since before I could see the top of the counter. I took this passion with me through life and continued my education at Le Cordon Bleu College of Culinary Arts. Even though I have my degree in savory food, sweets were what captured my heart. Since 2010, I have been making delicious sweets that range from simply sweet to decadently delicious.",
                  website: "likehoneybakery.com",
                  webshop: "",
                  facebook: "likehoneybakery",
                  twitter: "",
                )
madelyn.skip_confirmation!
madelyn.admin = false
madelyn.save!(validate: false)

tahila = User.new( first_name: "Tahila",
                  last_name: "Mintz",
                  birthday: "1980-01-01 17:00:00",
                  email: "tahila@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                  bio: "Tahila Shireem Chavez Mintz is an Austin based photographer. She works nationally and internationally, focusing predominately on culture, women, and indigenous traditions. Her work is lens, collage and bead based. She received her MFA from the University of Texas at Austin, and studied at Filmova a televizni fakulta akademie Prague, Czech Republic.",
                  website: "shireemimaging.com",
                  webshop: "",
                  facebook: "",
                  twitter: "",
                )
tahila.skip_confirmation!
tahila.admin = false
tahila.save!(validate: false)

teruko = User.new( first_name: "Teruko",
                  last_name: "Nimura",
                  birthday: "1980-01-01 17:00:00",
                  email: "teruko@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                  bio: "Teruko Nimura is an Austin based artist who creates mixed media installations and sculptures exploring ideas of collective efforts, Asian customs, and personal history using ceramics, plaster, fabric, paper, wax, wood, and other materials.",
                  website: "terukonimura.net",
                  webshop: "",
                  facebook: "",
                  twitter: "",
                )
teruko.skip_confirmation!
teruko.admin = false
teruko.save!(validate: false)

melissa = User.new( first_name: "Melissa",
                  last_name: "Chapman",
                  birthday: "1980-01-01 17:00:00",
                  email: "melissa@girlsguild.com",
                  password: "password",
                  password_confirmation: "password",
                  terms_of_service: true,
                  bio: "A recent transplant hailing from Oregon but originally from Georgia (this is not my first southern rodeo), I moved to Texas in mid-August to attend school at the Austin Center for Design. My love for jewelry making dates back to middle school days when I would spend hours and hours making precious beaded creations on my bedroom floor. While living in Portland, my love took a turn for the serious and I began first selling on Etsy and then most recently on Fab.com. We are also in the process of setting up wholesale accounts in stores and looking to grow in this way. The business is growing in lots of interesting ways and remains open to grow in areas that make sense to me. If an apprentice sees this and is excited to explore a particular aspect of the design or business, I remain open to considering all proposals!",
                  website: "stoneandsmith.com",
                  webshop: "etsy.com/shop/stoneandsmith",
                  facebook: "",
                  twitter: "",
                )
melissa.skip_confirmation!
melissa.admin = false
melissa.save!(validate: false)

#APPRENTICESHIPS FOR TESTING RAKE TASKS
test1 = Apprenticeship.new( "user_id"=>5,
                            "host_firstname"=>"Martha",
                            "host_lastname"=>"Smith",
                            "legal_name"=>"Martha Smith",
                            "host_business"=>"",
                            "topic"=>"Test1: Filled Apprenticeship",
                            "kind"=>"Production",
                            "description"=>"1. Should get a followup email the day we seed, 2. then transition to completed the day after seeding",
                            "skill_list"=>"'information architecture','front-end development','back-end development'",
                            "tool_list"=>"'Ruby on Rails','HTML5','HAML','CSS3','Sass','Javascript','text editor','Chrome Developer Tools','Git'",
                            "requirement_list"=>"",
                            "other_needs"=>"",
                            "age_min"=>"14",
                            "age_max"=>"99",
                            "registration_max"=>"2",
                            "begins_at"=>Date.today-7.days,
                            "ends_at"=>Date.today+1.days,
                            "datetime_tba"=>"0",
                            "hours"=>"4",
                            "hours_per"=>"week",
                            "location_address"=>"1309 Chestnut Ave",
                            "location_address2"=>"",
                            "location_city"=>"Austin",
                            "location_state"=>"TX",
                            "location_zipcode"=>"78704",
                            "location_private"=>"1",
                            "location_nbrhood"=>"East Austin",
                            "location_varies"=>"0",
                            "respect_my_style"=>"1",
                            "stripe_card_token"=>"",
                            "permission"=>"1",
                            "availability"=>"M-F, 3-7pm. Flexible on weekend days.",
                            "state"=>"filled",
                            )
test1.save!(validate:false)

test1_app = AppSignup.new(    "user_id"=>6,
                              "event_id"=>1,
                              "happywhen"=>"1. Should get a followup email the day we seed, 2. then transition to completed the day after seeding",
                              "collaborate"=>"I like working together on projects because it allows for a better flow of ideas. Because everyone perceives and processes ideas differently, collaborations allow for more ideas to bounce between people and develop, so the product will have gone through more development and have had more thought put into it opposed to a solo work.",
                              "interest"=>"I'm interested in seeing how an established artist works, especially seeing how they have turned their art into a small business. I am also interested because I work well with detail oriented tasks and I feel that this would make a productive apprentice.",
                              "experience"=>"Sculpture; mobiles, vessels, icons, collages, installation. Using materials and tools such as; Clay (hand building, throwing on a wheel), rubber carving, shrink plastic, printmaking, origami, wire, jeweler's saw, sheet metal, wax casting, plaster bandaging, and paper casting. In these processes I have worked on some larger pieces but mostly I have worked on a smaller, more detailed scale.",
                              "requirements"=>"1",
                              "confirm_available"=>"1",
                              "preferred_times"=>"Best days would be on weekends, some week day afternoons could work.",
                              "confirm_unpaid"=>"1",
                              "confirm_fee"=>"1",
                              "parent_name"=>"Mama Jones",
                              "parent_phone"=>"321-321-4321",
                              "parent_email"=>"mamajones@girlsguild.com",
                              "parents_waiver"=>"1",
                              "waiver"=>"1",
                              "charge_id"=>"anystringwilldo",
                              "state"=>"confirmed",
                            )
test1_app.save!(validate: false)

test1_app_state_stamp = test1_app.state_stamps.create!( state: "confirmed",
                                                          stamp: Date.today-3,
                                                          )

test1_app2 = AppSignup.new(   "user_id"=>7,
                              "event_id"=>1,
                              "happywhen"=>"1. Should get a followup email the day we seed, 2. then transition to completed the day after seeding",
                              "collaborate"=>"I like working together on projects because it allows for a better flow of ideas. Because everyone perceives and processes ideas differently, collaborations allow for more ideas to bounce between people and develop, so the product will have gone through more development and have had more thought put into it opposed to a solo work.",
                              "interest"=>"I'm interested in seeing how an established artist works, especially seeing how they have turned their art into a small business. I am also interested because I work well with detail oriented tasks and I feel that this would make a productive apprentice.",
                              "experience"=>"Sculpture; mobiles, vessels, icons, collages, installation. Using materials and tools such as; Clay (hand building, throwing on a wheel), rubber carving, shrink plastic, printmaking, origami, wire, jeweler's saw, sheet metal, wax casting, plaster bandaging, and paper casting. In these processes I have worked on some larger pieces but mostly I have worked on a smaller, more detailed scale.",
                              "requirements"=>"1",
                              "confirm_available"=>"1",
                              "preferred_times"=>"Best days would be on weekends, some week day afternoons could work.",
                              "confirm_unpaid"=>"1",
                              "confirm_fee"=>"1",
                              "parent_name"=>"Mama Kauffman",
                              "parent_phone"=>"789-789-7890",
                              "parent_email"=>"mamakauffman@girlsguild.com",
                              "parents_waiver"=>"1",
                              "waiver"=>"1",
                              "charge_id"=>"anystringwilldo",
                              "state"=>"confirmed",
                            )
test1_app2.save!(validate: false)

test1_app2_state_stamp = test1_app2.state_stamps.create!( state: "confirmed",
                                                          stamp: Date.today-3,
                                                          )

test2 = Apprenticeship.new( "user_id"=>9,
                            "host_firstname"=>"Nicole",
                            "host_lastname"=>"Anderson",
                            "legal_name"=>"Nicole Anderson",
                            "host_business"=>"",
                            "topic"=>"Test 2: Accepted Apprenticeship",
                            "kind"=>"Production",
                            "description"=>"1. Should get a followup email the day we seed, 2. then transition to completed the day after seeding",
                            "skill_list"=>"'information architecture','front-end development','back-end development'",
                            "tool_list"=>"'Ruby on Rails','HTML5','HAML','CSS3','Sass','Javascript','text editor','Chrome Developer Tools','Git'",
                            "requirement_list"=>"",
                            "other_needs"=>"",
                            "age_min"=>"14",
                            "age_max"=>"99",
                            "registration_max"=>"2",
                            "begins_at"=>Date.today-7.days,
                            "ends_at"=>Date.today+1.days,
                            "datetime_tba"=>"0",
                            "hours"=>"4",
                            "hours_per"=>"week",
                            "location_address"=>"1309 Chestnut Ave",
                            "location_address2"=>"",
                            "location_city"=>"Austin",
                            "location_state"=>"TX",
                            "location_zipcode"=>"78704",
                            "location_private"=>"1",
                            "location_nbrhood"=>"East Austin",
                            "location_varies"=>"0",
                            "respect_my_style"=>"1",
                            "stripe_card_token"=>"",
                            "permission"=>"1",
                            "availability"=>"M-F, 3-7pm. Flexible on weekend days.",
                            "state"=>"accepted",
                            )
test2.save!(validate:false)

test2_app = AppSignup.new(  "user_id"=>10,
                            "event_id"=>2,
                            "happywhen"=>"1. Should get a followup email the day we seed, 2. then transition to completed the day after seeding",
                            "collaborate"=>"I like working together on projects because it allows for a better flow of ideas. Because everyone perceives and processes ideas differently, collaborations allow for more ideas to bounce between people and develop, so the product will have gone through more development and have had more thought put into it opposed to a solo work.",
                            "interest"=>"I'm interested in seeing how an established artist works, especially seeing how they have turned their art into a small business. I am also interested because I work well with detail oriented tasks and I feel that this would make a productive apprentice.",
                            "experience"=>"Sculpture; mobiles, vessels, icons, collages, installation. Using materials and tools such as; Clay (hand building, throwing on a wheel), rubber carving, shrink plastic, printmaking, origami, wire, jeweler's saw, sheet metal, wax casting, plaster bandaging, and paper casting. In these processes I have worked on some larger pieces but mostly I have worked on a smaller, more detailed scale.",
                            "requirements"=>"1",
                            "confirm_available"=>"1",
                            "preferred_times"=>"Best days would be on weekends, some week day afternoons could work.",
                            "confirm_unpaid"=>"1",
                            "confirm_fee"=>"1",
                            "state"=>"confirmed",
                            )
test2_app.save!(validate: false)

test2_app_state_stamp = test2_app.state_stamps.create!( state: "confirmed",
                                                        stamp: Date.today-3,
                                                      )

test2_app2 = AppSignup.new( "user_id"=>11,
                            "event_id"=>2,
                            "happywhen"=>"1. Should get a followup email the day we seed, 2. then transition to completed the day after seeding",
                            "collaborate"=>"I like working together on projects because it allows for a better flow of ideas. Because everyone perceives and processes ideas differently, collaborations allow for more ideas to bounce between people and develop, so the product will have gone through more development and have had more thought put into it opposed to a solo work.",
                            "interest"=>"I'm interested in seeing how an established artist works, especially seeing how they have turned their art into a small business. I am also interested because I work well with detail oriented tasks and I feel that this would make a productive apprentice.",
                            "experience"=>"Sculpture; mobiles, vessels, icons, collages, installation. Using materials and tools such as; Clay (hand building, throwing on a wheel), rubber carving, shrink plastic, printmaking, origami, wire, jeweler's saw, sheet metal, wax casting, plaster bandaging, and paper casting. In these processes I have worked on some larger pieces but mostly I have worked on a smaller, more detailed scale.",
                            "requirements"=>"1",
                            "confirm_available"=>"1",
                            "preferred_times"=>"Best days would be on weekends, some week day afternoons could work.",
                            "confirm_unpaid"=>"1",
                            "confirm_fee"=>"1",
                            "state"=>"accepted",
                          )
test2_app2.save!(validate: false)

test2_app2_state_stamp = test2_app2.state_stamps.create!( state: "accepted",
                                                          stamp: Date.today-3,
                                                          )

test2_app3 = AppSignup.new( "user_id"=>12,
                            "event_id"=>2,
                            "happywhen"=>"No state change, no emails",
                            "collaborate"=>"I like working together on projects because it allows for a better flow of ideas. Because everyone perceives and processes ideas differently, collaborations allow for more ideas to bounce between people and develop, so the product will have gone through more development and have had more thought put into it opposed to a solo work.",
                            "interest"=>"I'm interested in seeing how an established artist works, especially seeing how they have turned their art into a small business. I am also interested because I work well with detail oriented tasks and I feel that this would make a productive apprentice.",
                            "experience"=>"Sculpture; mobiles, vessels, icons, collages, installation. Using materials and tools such as; Clay (hand building, throwing on a wheel), rubber carving, shrink plastic, printmaking, origami, wire, jeweler's saw, sheet metal, wax casting, plaster bandaging, and paper casting. In these processes I have worked on some larger pieces but mostly I have worked on a smaller, more detailed scale.",
                            "requirements"=>"1",
                            "confirm_available"=>"1",
                            "preferred_times"=>"Best days would be on weekends, some week day afternoons could work.",
                            "confirm_unpaid"=>"1",
                            "confirm_fee"=>"1",
                            "state"=>"declined",
                          )
test2_app3.save!(validate: false)

test2_app3_state_stamp = test2_app3.state_stamps.create!( state: "declined",
                                                          stamp: Date.today-3,
                                                          )

test3 = Apprenticeship.new( "user_id"=>13,
                            "host_firstname"=>"Natalie",
                            "host_lastname"=>"Davis",
                            "legal_name"=>"Natalie Davis",
                            "host_business"=>"",
                            "topic"=>"Control 1: Completed Apprenticeship",
                            "kind"=>"Production",
                            "description"=>"No state change, no emails",
                            "skill_list"=>"'information architecture','front-end development','back-end development'",
                            "tool_list"=>"'Ruby on Rails','HTML5','HAML','CSS3','Sass','Javascript','text editor','Chrome Developer Tools','Git'",
                            "requirement_list"=>"",
                            "other_needs"=>"",
                            "age_min"=>"14",
                            "age_max"=>"99",
                            "registration_max"=>"2",
                            "begins_at"=>Date.today-30.days,
                            "ends_at"=>Date.today-20.days,
                            "datetime_tba"=>"0",
                            "hours"=>"4",
                            "hours_per"=>"week",
                            "location_address"=>"1309 Chestnut Ave",
                            "location_address2"=>"",
                            "location_city"=>"Austin",
                            "location_state"=>"TX",
                            "location_zipcode"=>"78704",
                            "location_private"=>"1",
                            "location_nbrhood"=>"East Austin",
                            "location_varies"=>"0",
                            "respect_my_style"=>"1",
                            "stripe_card_token"=>"",
                            "permission"=>"1",
                            "availability"=>"M-F, 3-7pm. Flexible on weekend days.",
                            "state"=>"completed",
                            )
test3.save!(validate:false)

test3_app = AppSignup.new(  "user_id"=>14,
                            "event_id"=>3,
                            "happywhen"=>"No state change, no emails",
                            "collaborate"=>"I like working together on projects because it allows for a better flow of ideas. Because everyone perceives and processes ideas differently, collaborations allow for more ideas to bounce between people and develop, so the product will have gone through more development and have had more thought put into it opposed to a solo work.",
                            "interest"=>"I'm interested in seeing how an established artist works, especially seeing how they have turned their art into a small business. I am also interested because I work well with detail oriented tasks and I feel that this would make a productive apprentice.",
                            "experience"=>"Sculpture; mobiles, vessels, icons, collages, installation. Using materials and tools such as; Clay (hand building, throwing on a wheel), rubber carving, shrink plastic, printmaking, origami, wire, jeweler's saw, sheet metal, wax casting, plaster bandaging, and paper casting. In these processes I have worked on some larger pieces but mostly I have worked on a smaller, more detailed scale.",
                            "requirements"=>"1",
                            "confirm_available"=>"1",
                            "preferred_times"=>"Best days would be on weekends, some week day afternoons could work.",
                            "confirm_unpaid"=>"1",
                            "confirm_fee"=>"1",
                            "state"=>"completed",
                            )
test3_app.save!(validate: false)

test3_app_state_stamp = test3_app.state_stamps.create!( state: "completed",
                                                        stamp: Date.today-3,
                                                      )

test4 = Apprenticeship.new( "user_id"=>15,
                            "host_firstname"=>"Jennie",
                            "host_lastname"=>"Gray",
                            "legal_name"=>"Jennie Tudor Gray",
                            "host_business"=>"",
                            "topic"=>"Control 2: Future Apprenticeship",
                            "kind"=>"Production",
                            "description"=>"Should get a reminder email the day we seed, but no state change",
                            "skill_list"=>"'information architecture','front-end development','back-end development'",
                            "tool_list"=>"'Ruby on Rails','HTML5','HAML','CSS3','Sass','Javascript','text editor','Chrome Developer Tools','Git'",
                            "requirement_list"=>"",
                            "other_needs"=>"",
                            "age_min"=>"14",
                            "age_max"=>"99",
                            "registration_max"=>"2",
                            "begins_at"=>Date.today+4.days,
                            "ends_at"=>Date.today+30.days,
                            "datetime_tba"=>"0",
                            "hours"=>"4",
                            "hours_per"=>"week",
                            "location_address"=>"1309 Chestnut Ave",
                            "location_address2"=>"",
                            "location_city"=>"Austin",
                            "location_state"=>"TX",
                            "location_zipcode"=>"78704",
                            "location_private"=>"1",
                            "location_nbrhood"=>"East Austin",
                            "location_varies"=>"0",
                            "respect_my_style"=>"1",
                            "stripe_card_token"=>"",
                            "permission"=>"1",
                            "availability"=>"M-F, 3-7pm. Flexible on weekend days.",
                            "state"=>"accepted",
                            )
test4.save!(validate:false)

test4_app = AppSignup.new(  "user_id"=>16,
                            "event_id"=>4,
                            "happywhen"=>"Should get a reminder email the day we seed, but no state change",
                            "collaborate"=>"I like working together on projects because it allows for a better flow of ideas. Because everyone perceives and processes ideas differently, collaborations allow for more ideas to bounce between people and develop, so the product will have gone through more development and have had more thought put into it opposed to a solo work.",
                            "interest"=>"I'm interested in seeing how an established artist works, especially seeing how they have turned their art into a small business. I am also interested because I work well with detail oriented tasks and I feel that this would make a productive apprentice.",
                            "experience"=>"Sculpture; mobiles, vessels, icons, collages, installation. Using materials and tools such as; Clay (hand building, throwing on a wheel), rubber carving, shrink plastic, printmaking, origami, wire, jeweler's saw, sheet metal, wax casting, plaster bandaging, and paper casting. In these processes I have worked on some larger pieces but mostly I have worked on a smaller, more detailed scale.",
                            "requirements"=>"1",
                            "confirm_available"=>"1",
                            "preferred_times"=>"Best days would be on weekends, some week day afternoons could work.",
                            "confirm_unpaid"=>"1",
                            "confirm_fee"=>"1",
                            "state"=>"confirmed",
                            )
test4_app.save!(validate: false)

test4_app_state_stamp = test4_app.state_stamps.create!( state: "confirmed",
                                                        stamp: Date.today-3,
                                                      )

test4_app2 = AppSignup.new( "user_id"=>17,
                            "event_id"=>4,
                            "happywhen"=>"No state change, no emails",
                            "collaborate"=>"I like working together on projects because it allows for a better flow of ideas. Because everyone perceives and processes ideas differently, collaborations allow for more ideas to bounce between people and develop, so the product will have gone through more development and have had more thought put into it opposed to a solo work.",
                            "interest"=>"I'm interested in seeing how an established artist works, especially seeing how they have turned their art into a small business. I am also interested because I work well with detail oriented tasks and I feel that this would make a productive apprentice.",
                            "experience"=>"Sculpture; mobiles, vessels, icons, collages, installation. Using materials and tools such as; Clay (hand building, throwing on a wheel), rubber carving, shrink plastic, printmaking, origami, wire, jeweler's saw, sheet metal, wax casting, plaster bandaging, and paper casting. In these processes I have worked on some larger pieces but mostly I have worked on a smaller, more detailed scale.",
                            "requirements"=>"1",
                            "confirm_available"=>"1",
                            "preferred_times"=>"Best days would be on weekends, some week day afternoons could work.",
                            "confirm_unpaid"=>"1",
                            "confirm_fee"=>"1",
                            "state"=>"accepted",
                            )
test4_app2.save!(validate: false)

test4_app2_state_stamp = test4_app2.state_stamps.create!( state: "accepted",
                                                        stamp: Date.today-3,
                                                      )



#WORKSHOPS FOR TESTING RAKE TASKS
test5 = Workshop.new( "user_id"=>18,
                      "host_firstname"=>"Lisa",
                      "host_lastname"=>"Chouinard",
                      "legal_name"=>"Lisa Chouinard",
                      "host_business"=>"",
                      "topic"=>"Test 3: Filled workshop",
                      "description"=>"1. Should get a reminder email the day we seed, 2. then transition to completed 2 days from seeding, 3. then get a follow up 5 days from seeding",
                      "skill_list"=>"'splicing film','direct animation'",
                      "tool_list"=>"'16mm film','transparencies','ink','stamps','found objects','splicers','light box','projector'",
                      "requirement_list"=>"",
                      "other_needs"=>"",
                      "age_min"=>"10", "age_max"=>"100",
                      "registration_min"=>1,
                      "registration_max"=>2,
                      "begins_at"=>Date.today+3.days,
                      "begins_at_time"=>"10:00 AM",
                      "ends_at_time"=>"03:00 PM",
                      "datetime_tba"=>"0",
                      "location_address"=>"1309 Chestnut Ave.",
                      "location_address2"=>"",
                      "location_city"=>"Austin",
                      "location_state"=>"TX",
                      "location_zipcode"=>"78702",
                      "location_private"=>"0",
                      "location_nbrhood"=>"East Austin",
                      "price"=>"45",
                      "ends_at"=>Date.today+1.days,
                      "payment_options"=>"Paypal",
                      "paypal_email"=>"lee@girlsguild.com",
                      "sendcheck_address"=>"",
                      "sendcheck_address2"=>"",
                      "sendcheck_city"=>"",
                      "sendcheck_state"=>"",
                      "sendcheck_zip"=>"",
                      "respect_my_style"=>"0",
                      "permission"=>"1",
                      "state"=>"filled",
                    )
test5.save!(validate: false)

test5_signup = WorkSignup.new( "user_id"=>19,
                               "event_id"=>5,
                               "interest"=>"1. Should get first reminder email the day we seed, 2. then get second reminder email the day after seeding, 3. then transition to completed 2 days from seeding, 4. then get a follow up 5 days from seeding",
                               "waiver"=>"1",
                               "state"=>"confirmed",
                              )
test5_signup.save!(validate: false)

test5_signup_state_stamp = test5_signup.state_stamps.create!( state: "confirmed",
                                                        stamp: Date.today-3,
                                                      )

test5_signup2 = WorkSignup.new( "user_id"=>20,
                               "event_id"=>5,
                               "interest"=>"1. Should get first reminder email the day we seed, 2. then get second reminder email the day after seeding, 3. then transition to completed 2 days from seeding, 4. then get a follow up 5 days from seeding",
                               "waiver"=>"1",
                               "state"=>"confirmed",
                              )
test5_signup2.save!(validate: false)

test5_signup2_state_stamp = test5_signup2.state_stamps.create!( state: "confirmed",
                                                        stamp: Date.today-3,
                                                      )

test6 = Workshop.new( "user_id"=>21,
                      "host_firstname"=>"Maura",
                      "host_lastname"=>"Ambrose",
                      "legal_name"=>"Maura Ambrose",
                      "host_business"=>"",
                      "topic"=>"Test 4: Accepted workshop",
                      "description"=>"1. Should be completed the day after seeding, 2. then should get a follow up 4 days after seeding",
                      "skill_list"=>"'splicing film','direct animation'",
                      "tool_list"=>"'16mm film','transparencies','ink','stamps','found objects','splicers','light box','projector'",
                      "requirement_list"=>"",
                      "other_needs"=>"",
                      "age_min"=>"10", "age_max"=>"100",
                      "registration_min"=>1,
                      "registration_max"=>3,
                      "begins_at"=>Date.today+2.days,
                      "begins_at_time"=>"10:00 AM",
                      "ends_at_time"=>"03:00 PM",
                      "datetime_tba"=>"0",
                      "location_address"=>"1309 Chestnut Ave.",
                      "location_address2"=>"",
                      "location_city"=>"Austin",
                      "location_state"=>"TX",
                      "location_zipcode"=>"78702",
                      "location_private"=>"0",
                      "location_nbrhood"=>"East Austin",
                      "price"=>"45",
                      "ends_at"=>Date.today,
                      "payment_options"=>"Paypal",
                      "paypal_email"=>"lee@girlsguild.com",
                      "sendcheck_address"=>"",
                      "sendcheck_address2"=>"",
                      "sendcheck_city"=>"",
                      "sendcheck_state"=>"",
                      "sendcheck_zip"=>"",
                      "respect_my_style"=>"0",
                      "permission"=>"1",
                      "state"=>"accepted",
                    )
test6.save!(validate: false)

test6_signup = WorkSignup.new( "user_id"=>22,
                               "event_id"=>6,
                               "interest"=>"1. Should get second reminder email the day we seed, 2. then should be completed the day after seeding, 3. then should get a follow up 4 days after seeding",
                               "waiver"=>"1",
                               "work_first_reminder_sent"=>true,
                               "state"=>"confirmed",
                              )
test6_signup.save!(validate: false)

test6_signup_state_stamp = test6_signup.state_stamps.create!( state: "confirmed",
                                                        stamp: Date.today-3,
                                                      )

test6_signup2 = WorkSignup.new( "user_id"=>23,
                               "event_id"=>6,
                               "interest"=>"1. Should get FIRST reminder email the day we seed, 2. then should be completed the day after seeding, 3. then should get a follow up 4 days after seeding",
                               "waiver"=>"1",
                               "work_second_reminder_sent"=>true,
                               "state"=>"confirmed",
                              )
test6_signup2.save!(validate: false)

test6_signup2_state_stamp = test6_signup2.state_stamps.create!( state: "confirmed",
                                                        stamp: Date.today-3,
                                                      )

test7 = Workshop.new( "user_id"=>24,
                      "host_firstname"=>"Elizabeth",
                      "host_lastname"=>"Chiles",
                      "legal_name"=>"Elizabeth Chiles",
                      "host_business"=>"",
                      "topic"=>"Test 5: Workshop to be canceled",
                      "description"=>"1. Should be canceled the day after seeding",
                      "skill_list"=>"'splicing film','direct animation'",
                      "tool_list"=>"'16mm film','transparencies','ink','stamps','found objects','splicers','light box','projector'",
                      "requirement_list"=>"",
                      "other_needs"=>"",
                      "age_min"=>"10", "age_max"=>"100",
                      "registration_min"=>3,
                      "registration_max"=>8,
                      "begins_at"=>Date.today+1.days,
                      "begins_at_time"=>"10:00 AM",
                      "ends_at_time"=>"03:00 PM",
                      "datetime_tba"=>"0",
                      "location_address"=>"1309 Chestnut Ave.",
                      "location_address2"=>"",
                      "location_city"=>"Austin",
                      "location_state"=>"TX",
                      "location_zipcode"=>"78702",
                      "location_private"=>"0",
                      "location_nbrhood"=>"East Austin",
                      "price"=>"45",
                      "ends_at"=>Date.today+1.days,
                      "payment_options"=>"Paypal",
                      "paypal_email"=>"lee@girlsguild.com",
                      "sendcheck_address"=>"",
                      "sendcheck_address2"=>"",
                      "sendcheck_city"=>"",
                      "sendcheck_state"=>"",
                      "sendcheck_zip"=>"",
                      "respect_my_style"=>"0",
                      "permission"=>"1",
                      "state"=>"accepted",
                    )
test7.save!(validate: false)

test7_signup = WorkSignup.new( "user_id"=>25,
                               "event_id"=>7,
                               "interest"=>"1. Should get second reminder email the day we seed, 2. then should be canceled the day after seeding",
                               "waiver"=>"1",
                               "work_first_reminder_sent"=>true,
                               "state"=>"confirmed",
                              )
test7_signup.save!(validate: false)

test7_signup_state_stamp = test7_signup.state_stamps.create!( state: "confirmed",
                                                        stamp: Date.today-3,
                                                      )

test7_signup2 = WorkSignup.new( "user_id"=>26,
                               "event_id"=>7,
                               "interest"=>"1. Should get second reminder email the day we seed, 2. then should be canceled the day after seeding",
                               "waiver"=>"1",
                               "work_first_reminder_sent"=>true,
                               "state"=>"confirmed",
                              )
test7_signup2.save!(validate: false)

test7_signup2_state_stamp = test7_signup2.state_stamps.create!( state: "confirmed",
                                                        stamp: Date.today-3,
                                                      )


test8 = Workshop.new( "user_id"=>27,
                      "host_firstname"=>"Adrienne",
                      "host_lastname"=>"Butler",
                      "legal_name"=>"Adrienne Butler",
                      "host_business"=>"",
                      "topic"=>"Control 3: Completed workshop",
                      "description"=>"No state change, no emails",
                      "skill_list"=>"'splicing film','direct animation'",
                      "tool_list"=>"'16mm film','transparencies','ink','stamps','found objects','splicers','light box','projector'",
                      "requirement_list"=>"",
                      "other_needs"=>"",
                      "age_min"=>"10", "age_max"=>"100",
                      "registration_min"=>1,
                      "registration_max"=>2,
                      "begins_at"=>Date.today-7.days,
                      "begins_at_time"=>"10:00 AM",
                      "ends_at_time"=>"03:00 PM",
                      "datetime_tba"=>"0",
                      "location_address"=>"1309 Chestnut Ave.",
                      "location_address2"=>"",
                      "location_city"=>"Austin",
                      "location_state"=>"TX",
                      "location_zipcode"=>"78702",
                      "location_private"=>"0",
                      "location_nbrhood"=>"East Austin",
                      "price"=>"45",
                      "ends_at"=>Date.today-9.days,
                      "payment_options"=>"Paypal",
                      "paypal_email"=>"lee@girlsguild.com",
                      "sendcheck_address"=>"",
                      "sendcheck_address2"=>"",
                      "sendcheck_city"=>"",
                      "sendcheck_state"=>"",
                      "sendcheck_zip"=>"",
                      "respect_my_style"=>"0",
                      "permission"=>"1",
                      "state"=>"completed",
                    )
test8.save!(validate: false)

test8_signup = WorkSignup.new( "user_id"=>28,
                               "event_id"=>8,
                               "interest"=>"No state change, no emails",
                               "waiver"=>"1",
                               "state"=>"completed",
                              )
test8_signup.save!(validate: false)

test8_signup_state_stamp = test8_signup.state_stamps.create!( state: "completed",
                                                        stamp: Date.today-12,
                                                      )

test8_signup2 = WorkSignup.new( "user_id"=>29,
                               "event_id"=>8,
                               "interest"=>"No state change, no emails",
                               "waiver"=>"1",
                               "state"=>"completed",
                              )
test8_signup2.save!(validate: false)

test8_signup2_state_stamp = test8_signup2.state_stamps.create!( state: "completed",
                                                        stamp: Date.today-12,
                                                      )


test9 = Workshop.new( "user_id"=>30,
                      "host_firstname"=>"Tahila",
                      "host_lastname"=>"Mintz",
                      "legal_name"=>"Tahila Mintz",
                      "host_business"=>"",
                      "topic"=>"Control 4: Future workshop",
                      "description"=>"No state change, no emails",
                      "skill_list"=>"'splicing film','direct animation'",
                      "tool_list"=>"'16mm film','transparencies','ink','stamps','found objects','splicers','light box','projector'",
                      "requirement_list"=>"",
                      "other_needs"=>"",
                      "age_min"=>"10", "age_max"=>"100",
                      "registration_min"=>1,
                      "registration_max"=>4,
                      "begins_at"=>Date.today+7.days,
                      "begins_at_time"=>"10:00 AM",
                      "ends_at_time"=>"03:00 PM",
                      "datetime_tba"=>"0",
                      "location_address"=>"1309 Chestnut Ave.",
                      "location_address2"=>"",
                      "location_city"=>"Austin",
                      "location_state"=>"TX",
                      "location_zipcode"=>"78702",
                      "location_private"=>"0",
                      "location_nbrhood"=>"East Austin",
                      "price"=>"45",
                      "ends_at"=>Date.today+5.days,
                      "payment_options"=>"Paypal",
                      "paypal_email"=>"lee@girlsguild.com",
                      "sendcheck_address"=>"",
                      "sendcheck_address2"=>"",
                      "sendcheck_city"=>"",
                      "sendcheck_state"=>"",
                      "sendcheck_zip"=>"",
                      "respect_my_style"=>"0",
                      "permission"=>"1",
                      "state"=>"accepted",
                    )
test9.save!(validate: false)

test9_signup = WorkSignup.new( "user_id"=>31,
                               "event_id"=>9,
                               "interest"=>"No state change, no emails",
                               "waiver"=>"1",
                               "state"=>"confirmed",
                              )
test9_signup.save!(validate: false)

test9_signup_state_stamp = test9_signup.state_stamps.create!( state: "confirmed",
                                                        stamp: Date.today-3,
                                                      )

test9_signup2 = WorkSignup.new( "user_id"=>32,
                               "event_id"=>9,
                               "interest"=>"No state change, no emails",
                               "waiver"=>"1",
                               "state"=>"confirmed",
                              )
test9_signup2.save!(validate: false)

test9_signup2_state_stamp = test9_signup2.state_stamps.create!( state: "confirmed",
                                                        stamp: Date.today-3,
                                                      )
#
#
#
#
#


#OLD APPRENTICESHIPS FROM LAUNCH
first_apprenticeship = melissa.apprenticeships.create!( "host_firstname"=>"Melissa",
                                                        "host_lastname"=>"Chapman",
                                                        "legal_name"=>"Melissa Chapman",
                                                        "host_business"=>"Stone + Smith",
                                                        "topic"=>"Jewelry Design",
                                                        "kind"=>"Production",
                                                        "description"=>"At two years old, this jewelry line is more than a one person operation and is looking for an apprentice to assist in all steps of the design and production process. Apprentices will learn: sketching designs, prototyping sketches, sourcing ethically produced materials, small business growth, mass production, packing and shipping mass orders, sporadic dance parties and hand stretching to keep it fun and healthy. No skills or previous experience is required. In the apprenticeships you'll learn the following tools and techniques...",
                                                        "skill_list"=>"'polishing','sanding','soldering','bezel setting','drilling','sawing','leather cutting','riveting','wire forming','color theory','mood boards','trend research'",
                                                        "tool_list"=>"'handsaw','flex shaft','hammers','leather punch','bench lathe','oxy acetylene torch','files','sandpaper','pliers'",
                                                        "requirement_list"=>"",
                                                        "other_needs"=>"",
                                                        "age_min"=>"14",
                                                        "age_max"=>"99",
                                                        "registration_max"=>"1",
                                                        "begins_at"=>"10/01/2014",
                                                        "ends_at"=>"12/01/2014",
                                                        "datetime_tba"=>"0",
                                                        "hours"=>"4",
                                                        "hours_per"=>"week",
                                                        "location_address"=>"Stone + Smith studio",
                                                        "location_address2"=>"",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78704",
                                                        "location_private"=>"1",
                                                        "location_nbrhood"=>"South Congress",
                                                        "location_varies"=>"0",
                                                        "respect_my_style"=>"1",
                                                        "stripe_card_token"=>"",
                                                        "permission"=>"1",
                                                        "availability"=>"M-F, 3-7pm. Flexible on weekend days.",
                                                     )


second_apprenticeship = teruko.apprenticeships.create!( "host_firstname"=>"Teruko Nimura &",
                                                        "host_lastname"=>"Tahila Mintz",
                                                        "legal_name"=>"Teruko Nimura",
                                                        "host_business"=>"",
                                                        "topic"=>"Installing & Running an Art Show",
                                                        "kind"=>"Event",
                                                        "description"=>"Apprentices will assist artists Teruko Nimura and Tahila Mintz in the preparation, creation, and installation of their community art project 'Potentiality' that will open at Up Collective on Saturday December 8th, 2012. The project includes two collaborative events on Saturday November 10th and Sunday November 18th during East Side Studio tours where you will help to engage and instruct the public on making objects that will be included in the final exhibition. You will also support the artists to install the work for approximately 15-20 hours between the dates of November 24-December 7.",
                                                        "skill_list"=>"'basic sewing','origami','education','community involvement'",
                                                        "tool_list"=>"'paper','fabric','hammers'",
                                                        "requirement_list"=>"",
                                                        "other_needs"=>"",
                                                        "age_min"=>"14",
                                                        "age_max"=>"99",
                                                        "registration_max"=>"2",
                                                        "begins_at"=>"10/01/2014",
                                                        "ends_at"=>"12/01/2014",
                                                        "datetime_tba"=>"0",
                                                        "hours"=>"4",
                                                        "hours_per"=>"week",
                                                        "location_address"=>"Up Collective",
                                                        "location_address2"=>"2326 East Cesar Chavez St.",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78702",
                                                        "location_private"=>"0",
                                                        "location_nbrhood"=>"East Austin",
                                                        "location_varies"=>"0",
                                                        "respect_my_style"=>"0",
                                                        "stripe_card_token"=>"",
                                                        "permission"=>"1",
                                                        "availability"=>"Flexible on weekend days.",
                                                     )
second_apprenticeship.save!(validate: false)

third_apprenticeship = madelyn.apprenticeships.create!( "host_firstname"=>"Madelyn",
                                                        "host_lastname"=>"Thompson",
                                                        "legal_name"=>"Madelyn Thompson",
                                                        "host_business"=>"Like Honey Bakery",
                                                        "topic"=>"Dessert Making",
                                                        "kind"=>"1-day",
                                                        "description"=>"'Bake the road not traveled' - We will make desserts that are truly unique, whether it's your favorite flavor turned on its head, or we work some dessert inception. Together, we will travel down the road not traveled and come out of the other side with something absolutely delicious.",
                                                        "skill_list"=>"'creating and adjusting recipes','understanding flavors','piping','baking/pastry-making','dessert decoration','serving/presentation skills'",
                                                        "tool_list"=>"'cooking utensils','knives','oven'",
                                                        "requirement_list"=>"",
                                                        "other_needs"=>"",
                                                        "age_min"=>"1",
                                                        "age_max"=>"99",
                                                        "registration_max"=>"1",
                                                        "begins_at"=>"10/01/2014",
                                                        "ends_at"=>"12/01/2014",
                                                        "datetime_tba"=>"0",
                                                        "hours"=>"4",
                                                        "hours_per"=>"week",
                                                        "location_address"=>"Like Honey Bakery",
                                                        "location_address2"=>"",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78703",
                                                        "location_private"=>"0",
                                                        "location_nbrhood"=>"West Austin",
                                                        "location_varies"=>"0",
                                                        "respect_my_style"=>"0",
                                                        "stripe_card_token"=>"",
                                                        "permission"=>"1",
                                                        "availability"=>"Flexible",
                                                     )

fourth_apprenticeship = teruko.apprenticeships.create!( "host_firstname"=>"Teruko",
                                                        "host_lastname"=>"Nimura",
                                                        "legal_name"=>"Teruko Nimura",
                                                        "host_business"=>"",
                                                        "topic"=>"Organizing an Art Auction",
                                                        "kind"=>"Event",
                                                        "description"=>"Apprentices will work closely with me to devise a plan and action items to promote, prepare, install, and host an Art auction event on June 27th to benefit a local artist/musician with cancer. This will include marketing, acquisition of artworks, delivery and installation of art, paperwork, documentation, and working at the event.",
                                                        "skill_list"=>"'photography','computer skills','database creation','graphic design','event planning','event management'",
                                                        "tool_list"=>"'Excel','Photoshop','camera','computer'",
                                                        "requirement_list"=>"",
                                                        "other_needs"=>"",
                                                        "age_min"=>"13",
                                                        "age_max"=>"99",
                                                        "registration_max"=>"4",
                                                        "begins_at"=>"10/01/2014",
                                                        "ends_at"=>"12/01/2014",
                                                        "datetime_tba"=>"0",
                                                        "hours"=>"4",
                                                        "hours_per"=>"week",
                                                        "location_address"=>"Up Collective",
                                                        "location_address2"=>"",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78702",
                                                        "location_private"=>"1",
                                                        "location_nbrhood"=>"East Austin",
                                                        "location_varies"=>"0",
                                                        "respect_my_style"=>"0",
                                                        "stripe_card_token"=>"",
                                                        "permission"=>"1",
                                                        "availability"=>"Flexible",
                                                     )

fifth_apprenticeship = cheyenne.apprenticeships.create!( "host_firstname"=>"Cheyenne &",
                                                        "host_lastname"=>"Diana",
                                                        "legal_name"=>"Jessica C. Weaver",
                                                        "host_business"=>"GirlsGuild",
                                                        "topic"=>"East Austin Studio Tour group show",
                                                        "kind"=>"Event",
                                                        "description"=>"GirlsGuild is organizing a group show and apprenticeship tour in tandem with the East Austin Studio Tour (EAST) for the weekend of November 17th-18th. We're looking for an apprentice to help us with: communicating with participating artists, organizing and curating the show, designing promotional materials for the event, social media around the event, hanging the show, distributing event materials, hosting and documenting the event with us at Conjunctured, breaking down the show and following up on the event... and brainstorming with us about what we haven't thought of yet! We're looking for 1-2 girls who are excited to learn and are willing to work with us at the Austin Center for Design in a fun but focused environment.",
                                                        "skill_list"=>"'art show installation','graphic design','event planning','event promotion','social media'",
                                                        "tool_list"=>"'Excel','Photoshop','cameras','hammers'",
                                                        "requirement_list"=>"",
                                                        "other_needs"=>"",
                                                        "age_min"=>"12",
                                                        "age_max"=>"99",
                                                        "registration_max"=>"2",
                                                        "begins_at"=>"10/01/2014",
                                                        "ends_at"=>"12/01/2014",
                                                        "datetime_tba"=>"0",
                                                        "hours"=>"4",
                                                        "hours_per"=>"week",
                                                        "location_address"=>"Austin Center for Design",
                                                        "location_address2"=>"1201 Hackberry St",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78702",
                                                        "location_private"=>"0",
                                                        "location_nbrhood"=>"East Austin",
                                                        "location_varies"=>"0",
                                                        "respect_my_style"=>"0",
                                                        "stripe_card_token"=>"",
                                                        "permission"=>"1",
                                                        "availability"=>"Flexible on weekday afternoons and weekends",
                                                     )

sixth_apprenticeship = adrienne.apprenticeships.create!( "host_firstname"=>"Adrienne",
                                                        "host_lastname"=>"Butler",
                                                        "legal_name"=>"Adrienne Butler",
                                                        "host_business"=>"",
                                                        "topic"=>"Printmaking",
                                                        "kind"=>"1 Day",
                                                        "description"=>"Join Adrienne at Texas State University to take a peek at the inner workings of a busy print shop. Learn what goes into printmaking, and get your hands dirty making your own hand-printed fabric.",
                                                        "skill_list"=>"'hand-printing','stenciling','stamping','printmaking'",
                                                        "tool_list"=>"'screens','stencils','stamps','fabric','paint','ink','craft knife','found objects'",
                                                        "requirement_list"=>"",
                                                        "other_needs"=>"",
                                                        "age_min"=>"12",
                                                        "age_max"=>"99",
                                                        "registration_max"=>"2",
                                                        "begins_at"=>"10/01/2014",
                                                        "ends_at"=>"10/15/2014",
                                                        "datetime_tba"=>"0",
                                                        "hours"=>"4",
                                                        "hours_per"=>"week",
                                                        "location_address"=>"Austin Center for Design",
                                                        "location_address2"=>"1201 Hackberry St",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78702",
                                                        "location_private"=>"0",
                                                        "location_nbrhood"=>"East Austin",
                                                        "location_varies"=>"0",
                                                        "respect_my_style"=>"0",
                                                        "stripe_card_token"=>"",
                                                        "permission"=>"1",
                                                        "availability"=>"Flexible",
                                                     )

seventh_apprenticeship = jessica.apprenticeships.create!( "host_firstname"=>"Jessica",
                                                        "host_lastname"=>"Tata",
                                                        "legal_name"=>"Jessica Tata",
                                                        "host_business"=>"Son of a Sailor",
                                                        "topic"=>"Jewelry Production",
                                                        "kind"=>"Production",
                                                        "description"=>"We've been growing, fast, and want to involve someone that has an interest in learning about the development of a small creative business. As a Production Apprentice, your position will focus on the production of our line of jewelry and accessories. From hand-painting techniques on metal and wood, to basic leather working skills, you will be involved in the creation of our goods from beginning to end. You will learn basic jewelry techniques that include assemblage and beading, as well as metal stamping. You will also have the opportunity to be involved with all aspects of small creative business, including using social media for outreach and marketing, interaction with customers, and learning about wholesale/retail relationships. While we do not require specific relevant experience in order to work with us, applicants should be confident working on small, detail oriented tasks, and have good manual dexterity. ",
                                                        "skill_list"=>"'hand painting leather','hand painting wood','hand painting metal','metal finishing','grinding','polishing','stamping','basic jewelry','leather techniques','assemblage','finishing','basic wood techniques','sanding','social media marketing','basic accounting and inventory','basic website management/maintenance'",
                                                        "tool_list"=>"'Wix','Etsy','Photoshop','Illustrator','InDesign','Quick Books','Stitch Labs','Mail Chimp','chain nose pliers','round nose pliers','wire cutters','bead crimpers','thread burners','metal stamps','dremel tools','leather hole punches','rivet awl','ball peen hammer,','mallet, rotary cutter','paint, leather sealer','epoxy'",
                                                        "requirement_list"=>"",
                                                        "other_needs"=>"",
                                                        "age_min"=>"18",
                                                        "age_max"=>"99",
                                                        "registration_max"=>"2",
                                                        "begins_at"=>"10/01/2014",
                                                        "ends_at"=>"10/15/2014",
                                                        "datetime_tba"=>"0",
                                                        "hours"=>"4",
                                                        "hours_per"=>"week",
                                                        "location_address"=>"Canopy Studios",
                                                        "location_address2"=>"916 Springdale Road",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78702",
                                                        "location_private"=>"0",
                                                        "location_nbrhood"=>"East Austin",
                                                        "location_varies"=>"0",
                                                        "respect_my_style"=>"0",
                                                        "stripe_card_token"=>"",
                                                        "permission"=>"1",
                                                        "availability"=>"This is a two month apprenticeship that would ideally begin by June 15th. We would love to have someone that will be able to contribute in a meaningful way to our production, and learn as much as possible in the process. In order to do this, 10-15 hours a week in time chunks no less than 3 hours would be ideal. That said, we are flexible with the exact dates and times of the apprenticeship. We are, however, closed on the weekends and will not be in studio, barring any special events. ",
                                                     )

eighth_apprenticeship = anna.apprenticeships.create!(    "host_firstname"=>"Anna",
                                                        "host_lastname"=>"Gieselman",
                                                        "legal_name"=>"Anna Gieselman",
                                                        "host_business"=>"Bee Amour",
                                                        "topic"=>"Jewelry",
                                                        "kind"=>"Production",
                                                        "description"=>"Presently she is seeking an apprentice to help with production of her line. Some skills that the apprentice will learn are basic metal fabrication, soldering, finishing out cast pieces, and other fun metal work processes. There may also be marketing projects and fun jewelry events that the apprentice can be a part of.",
                                                        "skill_list"=>"'jewelry fabrication'",
                                                        "tool_list"=>"'jewelry hammers','metals','solder'",
                                                        "requirement_list"=>"",
                                                        "other_needs"=>"",
                                                        "age_min"=>"13",
                                                        "age_max"=>"18",
                                                        "registration_max"=>"2",
                                                        "begins_at"=>"10/01/2014",
                                                        "ends_at"=>"10/15/2014",
                                                        "datetime_tba"=>"0",
                                                        "hours"=>"4",
                                                        "hours_per"=>"week",
                                                        "location_address"=>"Anna's Studio",
                                                        "location_address2"=>"1201 Hackberry St",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78702",
                                                        "location_private"=>"1",
                                                        "location_nbrhood"=>"East Austin",
                                                        "location_varies"=>"0",
                                                        "respect_my_style"=>"0",
                                                        "stripe_card_token"=>"",
                                                        "permission"=>"1",
                                                        "availability"=>"Flexible",
                                                     )

ninth_apprenticeship = callen.apprenticeships.create!( "host_firstname"=>"Callen",
                                                        "host_lastname"=>"Thompson",
                                                        "legal_name"=>"Callen Thompson",
                                                        "host_business"=>"Texas Land Conservancy",
                                                        "topic"=>"Gala Organizing & Hosting",
                                                        "kind"=>"Event",
                                                        "description"=>"Austin artist and non-profit administrator, Callie Thompson, is accepting two apprentices for the Texas Land Conservancy 30th Anniversary Gala on December 1st, a beautiful, outdoor, tented event for 350 guests, headlined by Austin indie-rock orchestra, Mother Falcon. Callie will teach the apprentices how to craft a creative, non-profit event: from handmade decorations to event entertainment, volunteers, donor relationships, relationships with caterers and beer/tequila donors, social media/media relations and collaborations with local businesses. You will learn a basic understanding of how to run an event from this week-long apprenticeship, and after the apprenticeship, Callie is available as a resource to you whenever you need advising on your events or projects. ",
                                                        "skill_list"=>"'event planning','volunteer coordination','hand-made decorations'",
                                                        "tool_list"=>"'Excell','Photoshop'",
                                                        "requirement_list"=>"",
                                                        "other_needs"=>"",
                                                        "age_min"=>"20",
                                                        "age_max"=>"99",
                                                        "registration_max"=>"2",
                                                        "begins_at"=>"10/01/2014",
                                                        "ends_at"=>"10/15/2014",
                                                        "datetime_tba"=>"0",
                                                        "hours"=>"4",
                                                        "hours_per"=>"week",
                                                        "location_address"=>"Texas Land Conservancy office in Oak Hill & gala event venue near 2222 and 360",
                                                        "location_address2"=>"1201 Hackberry St",
                                                        "location_city"=>"Austin",
                                                        "location_state"=>"TX",
                                                        "location_zipcode"=>"78702",
                                                        "location_private"=>"1",
                                                        "location_nbrhood"=>"Oak Hill",
                                                        "location_varies"=>"0",
                                                        "respect_my_style"=>"0",
                                                        "stripe_card_token"=>"",
                                                        "permission"=>"1",
                                                        "availability"=>"Flexible",
                                                     )

Event.all.each do |event|
  event.generate_title
end


