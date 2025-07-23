DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS articles;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS follows;
DROP TABLE IF EXISTS likes;
DROP TABLE IF EXISTS notify;

-- AUTOINCREMENT: will be increased automatically, do not need manually creation
-- ON DELETE CASCADE: if the dependency is deleted, the dependency will be deleted.

-- Create users table
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    create_date DATE DEFAULT CURRENT_DATE,
    realname VARCHAR(100) NOT NULL,
    description TEXT,
    avatar_url VARCHAR(255),
    role VARCHAR(5) DEFAULT 'user' CHECK(role IN('user', 'admin')),
    dob DATE
);

-- Create articles table
CREATE TABLE articles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    image VARCHAR(255),
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    create_date DATE DEFAULT CURRENT_DATE,
    update_date DATE DEFAULT CURRENT_DATE,
    likes INTEGER DEFAULT 0,
    userid INTEGER NOT NULL,
    FOREIGN KEY(userid) REFERENCES users(id) ON DELETE CASCADE
);

-- Create comments table
CREATE TABLE comments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    content TEXT NOT NULL,
    create_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    article_id INTEGER NOT NULL,
    parent_id INTEGER DEFAULT NULL,
    userid INTEGER NOT NULL,
    FOREIGN KEY(article_id) REFERENCES articles(id) ON DELETE CASCADE,
    FOREIGN KEY (userid)REFERENCES users(id) ON DELETE CASCADE, 
    FOREIGN KEY (parent_id)REFERENCES comments(id) ON DELETE CASCADE 
);

-- Create follow table
CREATE TABLE follows
(
    follower_id INTEGER NOT NULL,
    followed_id INTEGER NOT NULL,
    PRIMARY KEY (follower_id, followed_id),
    FOREIGN KEY (follower_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (followed_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create likes table
CREATE TABLE likes
(
    userid INTEGER NOT NULL,
    article_id INTEGER NOT NULL,
    PRIMARY KEY (userid, article_id),
    FOREIGN KEY (userid) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE
);

-- Create notify table
CREATE TABLE notify (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    article_id INTEGER NOT NULL,
    userid INTEGER NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (article_id) REFERENCES articles (id) ON DELETE CASCADE,
    FOREIGN KEY (userid) REFERENCES users (id) ON DELETE CASCADE
);



-- Insert users information
INSERT INTO users
    (username, password, create_date, realname, description, avatar_url, role, dob)
VALUES
    ('oliver_j_90', 'randomPass3', '2023-03-10', 'Oliver Jackson', 'Travel blogger from Auckland', 'images/avatar-boy-green.png', 'user', '1990-04-10'),
    ('emily_wildflower92', 'randomPass4', '2023-03-20', 'Emily White', 'Lover of nature and adventure', 'images/avatar-girl-pink.png', 'user', '1992-11-12'),
    ('george_brown_eats', 'randomPass5', '2023-03-25', 'George Brown', 'Food enthusiast exploring New Zealand', 'images/avatar-boy-green.png', 'user', '1994-02-03'),
    ('sophia_photographer91', 'randomPass6', '2023-03-28', 'Sophia Wilson', 'Avid hiker and photographer', 'images/avatar-girl-pink.png', 'user', '1991-06-22'),
    ('noah_the_explorer88', 'randomPass7', '2023-04-01', 'Noah Johnson', 'Traveling all around the world', 'images/avatar-boy-orange.png', 'user', '1988-09-15'),
    ('mia_nature_photography', 'randomPass8', '2023-04-05', 'Mia Roberts', 'Nature photographer and blogger', 'images/avatar-girl-blue.png', 'user', '1989-05-17'),
    ('liam_culture_93', 'randomPass9', '2023-04-10', 'Liam Davis', 'Cultural blogger sharing insights on New Zealand', 'images/avatar-boy-orange.png', 'user', '1993-10-05'),
    ('isabella_explorer95', 'randomPass10', '2023-04-15', 'Isabella Taylor', 'Explorer of hidden gems in New Zealand', 'images/avatar-girl-pink.png', 'user', '1995-08-28'),
    ('admin_john_doe', 'randomPass1', '2023-01-15', 'John Doe', 'Application founder', 'images/avatar-boy-green.png', 'admin', '1980-03-25'),
    ('jane_smith_admin85', 'randomPass2', '2023-02-10', 'Jane Smith', 'Application co-founder', 'images/avatar-girl-blue.png', 'admin', '1985-07-14');

-- Insert articles 1 of user1:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/milford_sound.jpg', 'Discovering the Majestic Beauty of Milford Sound',
        '
<p>Located deep in New Zealand''s Fiordland National Park, Milford Sound is an iconic destination that captivates visitors from all over the world. Often referred to as the "eighth wonder of the world," it is a stunning fiord characterized by its dramatic cliffs, cascading waterfalls, and serene waters. Milford Sound offers a unique glimpse into New Zealand''s untamed wilderness and is a must-visit for anyone seeking to experience the raw beauty of the country.</p>

<p>The journey to Milford Sound is an adventure in itself. Whether you choose to drive or take a guided tour from Queenstown or Te Anau, the route winds through some of the most breathtaking scenery in the world. The Milford Road, known as one of the most scenic drives in the Southern Hemisphere, passes through dense rainforests, towering mountains, and crystal-clear rivers. Highlights of the drive include the Eglinton Valley, with its sweeping plains and snow-capped peaks, and the Mirror Lakes, which perfectly reflect the surrounding mountains on still days.</p>

<p>Upon arriving at Milford Sound, the first thing that strikes visitors is the grandeur of Mitre Peak, which rises an astounding 1,692 meters straight out of the water. This iconic mountain is one of the most photographed landmarks in New Zealand, and it sets the stage for the awe-inspiring natural beauty that unfolds throughout the fiord.</p>

<p>A boat cruise is the most popular way to explore Milford Sound, and several operators offer trips that range from short scenic cruises to overnight excursions. As the boat glides through the calm waters, towering cliffs rise on either side, their faces streaked with waterfalls that tumble hundreds of meters into the fiord. Two of the most famous waterfalls, Stirling and Bowen Falls, are fed by the heavy rainfall that the area receives – up to 7 meters per year in some places. Rain, though frequent, adds to the mystical atmosphere, as hundreds of temporary waterfalls appear on the cliffs, creating a truly magical sight.</p>

<p>Wildlife is abundant in Milford Sound, and it''s not uncommon to spot dolphins swimming alongside the boats or seals lounging on the rocks near the shore. The fiord is also home to a variety of bird species, including the rare Fiordland crested penguin, one of the world''s rarest penguins. Kayaking is another way to get close to the wildlife and explore the hidden corners of the fiord that are inaccessible by boat. Paddling through the calm waters, you''ll feel a profound sense of peace and isolation, surrounded by the towering peaks and untouched wilderness.</p>

<p>For those who prefer to stay on land, the Milford Track is considered one of the finest walking trails in the world. The 53-kilometer trek takes hikers through lush rainforests, across alpine passes, and along roaring rivers, with the final destination being the shores of Milford Sound itself. The track is a multi-day hike, and it offers a once-in-a-lifetime opportunity to experience New Zealand''s natural beauty up close. Along the way, hikers are treated to stunning views of the Clinton Valley, the dramatic Mackinnon Pass, and the thundering Sutherland Falls, one of the tallest waterfalls in the world.</p>

<p>What sets Milford Sound apart from other destinations is the sheer scale and untouched nature of the landscape. The fiord was carved by glaciers during the last Ice Age, and the result is a dramatic, otherworldly environment where humans feel like mere visitors in a vast, ancient landscape. The weather is highly unpredictable, with sunshine, rain, and mist often occurring all within the same day. Yet, no matter the conditions, the beauty of Milford Sound is undeniable.</p>

<p>For visitors seeking more than just a day trip, there are options to stay overnight in the remote lodges scattered around the area. One of the most unique experiences is the overnight boat cruise, where guests can stay on board and watch the sunset over the fiord, followed by stargazing in one of the darkest skies in the world. The lack of light pollution in this remote corner of New Zealand offers unparalleled views of the night sky, with the Milky Way and even the Southern Lights sometimes visible.</p>

<p>While Milford Sound is a popular destination, it retains a sense of isolation and untouched beauty. The remoteness of the location, combined with its dramatic scenery and rich wildlife, makes it one of the most unforgettable places in New Zealand. Visitors often leave Milford Sound with a sense of awe and reverence for the natural world, as it offers a glimpse into the power and majesty of nature in its most raw and unspoiled form.</p>

<p>In conclusion, Milford Sound is more than just a place – it''s an experience that leaves a lasting impression on all who visit. From the towering peaks of Mitre Peak to the cascading waterfalls and serene waters, every moment spent in Milford Sound is a reminder of the incredible beauty that the natural world has to offer. Whether you explore it by boat, on foot, or from the seat of a kayak, Milford Sound will undoubtedly be one of the highlights of your journey through New Zealand.</p>',
        '2023-06-01', '2023-06-01', 5, '1');

-- Insert article 2 of user1:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/tongariro_crossing.jpg', 'Adventuring Through the Beautiful Tongariro Alpine Crossing',
        '
<p>The <strong>Tongariro Alpine Crossing</strong> is widely regarded as one of the best one-day hikes in New Zealand, offering breathtaking scenery and a unique opportunity to experience the raw beauty of the volcanic landscape. This 19.4-kilometer trek takes you through the stunning <strong>Tongariro National Park</strong>, a UNESCO World Heritage site, and features dramatic craters, emerald lakes, and volcanic terrain.</p>

<h2>A Journey Through Volcanic Landscapes</h2>
<p>Starting at <strong>Mangatepopo Car Park</strong>, the trail quickly ascends into a world of striking landscapes shaped by volcanic activity. Hikers are greeted by the majestic views of <strong>Mount Ngauruhoe</strong>, known as <strong>Mount Doom</strong> from the "Lord of the Rings" trilogy. The iconic cone-shaped peak dominates the skyline, providing a breathtaking backdrop for your hike.</p>

<p>As you continue along the trail, you''ll encounter the vibrant <strong>Emerald Lakes</strong>, renowned for their stunning turquoise color. These lakes are the result of geothermal activity, and the contrast between the bright blue waters and the surrounding volcanic rock creates a mesmerizing scene. The lakes are often a perfect spot to take a break, enjoy a picnic, and soak in the breathtaking views.</p>

<h2>Rich Geothermal Activity</h2>
<p>One of the highlights of the Tongariro Alpine Crossing is the opportunity to witness the unique geothermal features of the area. The trail takes you past steaming vents, bubbling mud pools, and sulfurous landscapes that showcase the power of the earth beneath your feet. The smells and sights of the geothermal activity are reminders of the region''s volcanic history and add a unique element to the hike.</p>

<p>As you make your way towards the summit of the crossing, you''ll encounter a steep ascent known as the <strong>Devil''s Staircase</strong>. This challenging section rewards hikers with panoramic views of the surrounding valleys and mountains. The effort is worth it, as the vistas are absolutely stunning, providing incredible photo opportunities.</p>

<h2>A Cultural Experience</h2>
<p>The Tongariro Alpine Crossing is not just a hike; it is also steeped in cultural significance for the local Maori people. The mountains in the park are considered sacred, and the area holds deep spiritual meaning. Many guided tours offer insights into Maori culture, sharing stories and legends associated with the land.</p>

<p>Engaging with local guides enhances the hiking experience, allowing you to learn about the historical and cultural context of the area. This connection to the land adds depth to your understanding of New Zealand''s unique heritage.</p>

<h2>Preparation and Safety</h2>
<p>The Tongariro Alpine Crossing is a popular hike, but it is essential to come prepared. Weather conditions can change rapidly in the mountains, so dressing in layers and bringing sufficient water and snacks is crucial. Proper footwear is also important, as the terrain can be rocky and uneven.</p>

<p>Many hikers choose to complete the crossing in a single day, but there are options for multi-day hikes if you wish to explore more of the surrounding area. Guided tours are available for those who prefer a more structured experience, and they provide transportation to and from the trailhead.</p>

<h2>Conclusion</h2>
<p>The Tongariro Alpine Crossing is an adventure that showcases the incredible beauty and diversity of New Zealand''s landscapes. From volcanic craters to emerald lakes, every step along the trail reveals something new and awe-inspiring. Whether you''re an experienced hiker or a novice adventurer, this hike is a must-do when visiting New Zealand, offering a unique opportunity to connect with nature and appreciate the breathtaking scenery of the Tongariro National Park.</p>',
        '2023-07-10', '2023-07-10', 8, '1');

-- Insert article 3 of user1:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/catlins.jpg', 'The Enchanting Landscapes of the Catlins',
        '
<p>The <strong>Catlins</strong> is a hidden gem located in the southeastern corner of the South Island, known for its rugged coastlines, lush rainforests, and diverse wildlife. This enchanting region offers visitors a chance to explore untouched natural beauty, making it an ideal destination for those seeking adventure and tranquility away from the crowds.</p>

<h2>Stunning Coastal Scenery</h2>
<p>The coastline of the Catlins is dotted with dramatic cliffs, sandy beaches, and secluded bays. One of the must-visit spots is <strong>Nugget Point</strong>, where you can witness the stunning views of the rugged coastline and the famous lighthouse perched on the cliffs. The area is a haven for photographers, offering countless opportunities to capture the natural beauty of the landscape.</p>

<p>The <strong>Cathedral Caves</strong>, located near <strong>Owaka</strong>, are another highlight of the Catlins. These impressive caves can be accessed at low tide, and visitors can explore the stunning rock formations and arches that have been carved by the sea over thousands of years. The acoustics inside the caves are remarkable, creating a magical atmosphere that feels otherworldly.</p>

<h2>Diverse Wildlife</h2>
<p>The Catlins is home to a variety of wildlife, making it a fantastic destination for nature enthusiasts. The region is known for its birdlife, including the endangered <strong>yellow-eyed penguin</strong> and the rare <strong>kiwi</strong>. Wildlife spotting opportunities abound, and visitors can often see seals lounging on the rocky shores or dolphins playing in the surf.</p>

<p>For those interested in marine life, the Catlins offers excellent opportunities for kayaking and marine excursions. Kayaking along the coastline allows you to get up close to seals, sea lions, and a variety of bird species. The calm waters and stunning scenery make it a memorable experience for all ages.</p>

<h2>The Untamed Forests</h2>
<p>The lush rainforests of the Catlins provide a stark contrast to the rugged coastline, creating a unique ecosystem that supports diverse flora and fauna. The <strong>Catlins Forest Park</strong> offers numerous walking and hiking trails that wind through ancient trees, ferns, and moss-covered rocks.</p>

<p>One of the most popular hikes is the <strong>Mataura River Track</strong>, which takes you through beautiful scenery along the riverbanks. The sound of the flowing water and the vibrant colors of the forest create a peaceful and serene environment, perfect for those seeking a quiet escape into nature.</p>

<h2>Cultural Significance</h2>
<p>The Catlins also hold cultural significance for the local Maori people, who have a deep connection to the land. The region is steeped in history, with numerous historical sites and stories that reflect the rich heritage of the area. Engaging with local guides allows visitors to gain insights into the cultural significance of the landscape and its importance to the Maori people.</p>

<h2>Conclusion</h2>
<p>The Catlins is a captivating destination that showcases the stunning natural beauty and diversity of New Zealand. From the dramatic coastal scenery to the lush forests and diverse wildlife, the region offers a unique experience for all who visit. Whether you''re hiking through ancient rainforests, exploring the rugged coastline, or observing wildlife in its natural habitat, the Catlins promises an adventure filled with unforgettable memories and a deep appreciation for the wonders of nature.</p>',
        '2023-07-15', '2023-07-15', 3, '1');

-- Insert article 1 of user2:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/nz_beaches.jpg', 'Exploring the Hidden Beaches of New Zealand''s North Island',
        '<p>New Zealand is known for its dramatic landscapes, and while many people are familiar with its towering mountains and verdant forests, the country''s beaches are some of the most beautiful in the world. On the North Island, the coastline is dotted with hidden gems – beaches that are far less crowded than the popular spots like Piha or Cathedral Cove, yet equally stunning, if not more so. These hidden beaches offer visitors the chance to escape the hustle and bustle of daily life and immerse themselves in New Zealand''s natural beauty.</p>

<p>One such gem is <strong>Whale Bay</strong>, located near Raglan on the west coast of the North Island. Whale Bay is renowned for its surfing, attracting experienced surfers from all over the world who come to ride its powerful waves. But even for those who don''t surf, Whale Bay is a stunningly beautiful place. Surrounded by lush native vegetation and framed by rugged cliffs, the beach feels isolated and tranquil. The sound of the waves crashing against the shore, combined with the natural beauty of the surroundings, makes it an ideal place for quiet contemplation or a peaceful day at the beach.</p>

<p>For those who prefer calmer waters, <strong>Tawharanui Regional Park</strong> offers a pristine stretch of white sand beach and crystal-clear waters that are perfect for swimming, snorkeling, or simply relaxing. Located on the east coast of the North Island, this beach is less crowded than the nearby popular spots, making it a hidden paradise for nature lovers. The park itself is a haven for wildlife, with endangered species such as the kiwi and the North Island robin often spotted by visitors. Tawharanui is also home to a variety of native plants, adding to the sense of being immersed in New Zealand''s natural environment.</p>

<p>Another must-visit hidden beach is <strong>New Chums Beach</strong>, located on the Coromandel Peninsula. New Chums Beach is consistently ranked as one of the most beautiful beaches in the world, and for good reason. The beach is accessible only by a 30-minute walk through native bush, which helps to keep it relatively secluded and untouched. As you emerge from the trees and catch your first glimpse of the beach, it''s easy to see why it''s considered such a treasure. The golden sand stretches out before you, and the turquoise waters gently lap at the shore. With no development in sight, New Chums feels like a true paradise, a place where you can escape the modern world and connect with nature.</p>

<p>For adventurers willing to venture a bit further, <strong>Kai Iwi Lakes</strong>, located on the west coast of the North Island near Dargaville, offers a completely different beach experience. The lakes are a series of freshwater dune lakes with crystal-clear waters and white sand beaches, and they''re perfect for swimming, kayaking, and paddleboarding. The surrounding landscape is equally beautiful, with rolling sand dunes and native forests providing a scenic backdrop to the tranquil waters. Unlike some of the more popular beach destinations in New Zealand, Kai Iwi Lakes remains relatively undiscovered by tourists, making it the perfect spot for those looking for a peaceful retreat.</p>

<p>One of the most unique beaches on the North Island is <strong>Hot Water Beach</strong>, located on the east coast near Hahei. What makes Hot Water Beach so special is the natural hot springs that bubble up through the sand. Visitors can dig their own spa pools in the sand and relax in the warm, mineral-rich waters while enjoying the stunning views of the Pacific Ocean. The beach is best visited at low tide, when the hot water is accessible, and it''s a great spot to relax and unwind after a day of exploring the nearby Cathedral Cove or the Coromandel Peninsula.</p>

<p>No exploration of New Zealand''s hidden beaches would be complete without a visit to <strong>Karekare Beach</strong>, located just south of Piha on Auckland''s west coast. Karekare is a black sand beach, known for its wild beauty and dramatic scenery. The beach is framed by towering cliffs, and the powerful waves of the Tasman Sea crash against the shore with an intensity that can be both awe-inspiring and humbling. Despite its proximity to Auckland, Karekare remains relatively uncrowded, and its remote location adds to its allure. The beach is also famous for its appearance in the film "The Piano," which captured its haunting beauty on screen.</p>

<p>These hidden beaches are just a few examples of the natural beauty that can be found along New Zealand''s North Island coastline. Whether you''re seeking adventure, relaxation, or a deeper connection with nature, these beaches offer something for everyone. The relative seclusion of these spots allows visitors to experience the true beauty of New Zealand without the crowds, making them the perfect destinations for those looking to escape and unwind. From the rugged west coast to the serene east coast, the North Island''s hidden beaches are waiting to be discovered.</p>',
        '2023-07-05', '2023-07-05', 2, '2');

-- Insert article 2 of user2:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/abel_tasman.jpg', 'The Wonders of Abel Tasman National Park',
        '<p>Abel Tasman National Park is one of New Zealand''s most stunning coastal reserves, known for its beautiful beaches, lush forests, and crystal-clear waters. Located at the northern tip of the South Island, the park is a paradise for outdoor enthusiasts, offering a range of activities from hiking and kayaking to swimming and relaxing on the beach. This enchanting national park is a must-visit for anyone traveling to New Zealand.</p>

<p><strong>A Coastal Adventure</strong></p>
<p>The park is famous for its stunning coastline, with golden sandy beaches and tranquil bays that are perfect for swimming and sunbathing. <strong>Totaranui Beach</strong> is one of the most popular spots, offering pristine sands and crystal-clear waters. The beach is surrounded by lush native bush, providing a beautiful backdrop for a day of relaxation.</p>

<p>For those seeking adventure, kayaking along the coastline is a popular activity. Exploring the coastline by kayak allows you to get up close to secluded beaches, marine life, and stunning rock formations. Guided tours are available, providing opportunities to spot seals, dolphins, and various bird species as you paddle through the serene waters.</p>

<p><strong>The Abel Tasman Coast Track</strong></p>
<p>One of the best ways to experience the beauty of Abel Tasman National Park is by hiking the <strong>Abel Tasman Coast Track</strong>, one of New Zealand''s Great Walks. This 60-kilometer trail winds its way along the coastline, offering breathtaking views of the sea and surrounding landscapes. The track is well-maintained and suitable for all skill levels, making it accessible to both novice and experienced hikers.</p>

<p>The hike can be completed in three to five days, with plenty of campsites and huts available along the way. Many hikers choose to combine hiking with kayaking, allowing for a unique experience as they explore the coastline from both land and sea.</p>

<p><strong>Flora and Fauna</strong></p>
<p>The park is home to a diverse range of flora and fauna, with numerous native plant species and wildlife. The lush forests are filled with towering trees, including <strong>rimu</strong> and <strong>kahikatea</strong>, providing habitat for various birds such as the <strong>kiwi</strong> and the <strong>pukeko</strong>. Birdwatchers will delight in the opportunity to spot these unique species as they explore the park.</p>

<p>The coastal waters are rich in marine life, making the park a popular destination for snorkeling and diving. The clear waters reveal vibrant underwater ecosystems, allowing visitors to discover the colorful fish and marine creatures that inhabit the area.</p>

<p><strong>Cultural Heritage</strong></p>
<p>Abel Tasman National Park is not only a natural wonder but also holds cultural significance for the local Maori people. The area is rich in history and is associated with traditional Maori stories and legends. Engaging with local Maori guides offers visitors insights into the cultural heritage of the area, enhancing the overall experience.</p>

<p>Visitors can learn about the Maori connection to the land and the importance of preserving the natural environment. Cultural performances and storytelling sessions are often available, allowing for a deeper understanding of the Maori culture and its significance to New Zealand.</p>

<p><strong>Conclusion</strong></p>
<p>Abel Tasman National Park is a captivating destination that showcases the incredible beauty of New Zealand''s coastline and natural environment. Whether you''re hiking the scenic trails, kayaking along the stunning beaches, or immersing yourself in the local culture, the park offers an unforgettable experience for all who visit. It''s a place where nature and culture come together, creating memories that will last a lifetime.</p>',
        '2023-07-10', '2023-07-10', 1, '2');

-- Insert article 3 of user2:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/rotorua.jpg', 'The Scenic Beauty of Rotorua''s Geothermal Wonders',
        '<p>Rotorua, located on New Zealand''s North Island, is famous for its stunning geothermal activity, rich Maori culture, and beautiful landscapes. The area is renowned for its bubbling mud pools, steaming geysers, and natural hot springs, making it a must-visit destination for travelers seeking adventure and relaxation.</p>

<p><strong>Geothermal Marvels</strong></p>
<p>The geothermal wonders of Rotorua are truly remarkable. One of the most popular attractions is <strong>Te Puia</strong>, home to the famous <strong>Pohutu Geyser</strong>, which erupts several times a day, shooting boiling water high into the air. Visitors can witness this awe-inspiring spectacle while exploring the stunning geothermal landscape filled with bubbling mud pools and steaming vents.</p>

<p>Another highlight is the <strong>Wai-O-Tapu Thermal Wonderland</strong>, known for its colorful hot springs and unique geothermal features. The vibrant colors of the <strong>Champagne Pool</strong> and the striking <strong>Artist''s Palette</strong> make for incredible photo opportunities. The walking trails through this geothermal park allow visitors to immerse themselves in the otherworldly beauty of the landscape.</p>

<p><strong>Cultural Heritage</strong></p>
<p>Rotorua is not only about geothermal wonders; it is also rich in Maori culture and history. The local Maori community is deeply connected to the land, and visitors have the opportunity to engage with their culture through guided tours and cultural performances. A visit to a traditional <strong>marae</strong> (meeting house) provides insights into Maori customs, traditions, and stories.</p>

<p>Participating in a <strong>hangi</strong>, a traditional Maori feast cooked in an underground oven, is a highlight for many visitors. This communal dining experience offers a delicious introduction to Maori cuisine and an opportunity to connect with the local culture.</p>

<p><strong>Outdoor Adventures</strong></p>
<p>In addition to its geothermal wonders and cultural experiences, Rotorua offers a wide range of outdoor activities for adventure seekers. The region is known for its mountain biking trails, particularly the <strong>Redwoods Forest</strong>, which features a network of tracks suitable for all skill levels. Riders can enjoy breathtaking views of the towering redwood trees and lush landscapes as they navigate the trails.</p>

<p>For those seeking more adrenaline-pumping experiences, Rotorua is also home to <strong>Zorbing</strong>, where visitors roll down a hill inside a giant inflatable ball. This exhilarating activity is unique to New Zealand and provides a fun way to experience the beautiful surroundings.</p>

<p><strong>Conclusion</strong></p>
<p>Rotorua is a destination that captivates visitors with its stunning geothermal activity, rich Maori culture, and outdoor adventures. Whether you''re exploring the geothermal parks, learning about Maori heritage, or engaging in thrilling activities, Rotorua offers an unforgettable experience that showcases the beauty and diversity of New Zealand. It''s a place where nature, culture, and adventure come together, creating lasting memories for all who visit.</p>',
        '2023-07-15', '2023-07-15', 5, '2');

-- Insert article 1 of user 3:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/nz_cuisine.jpg', 'Tasting New Zealand''s Best Cuisine: From Hāngī to Pavlova',
        '<p>New Zealand''s diverse culinary landscape is a reflection of its unique blend of cultures, climates, and local ingredients. The country offers a delightful fusion of traditional Maori fare, European influences, and flavors inspired by its proximity to the Pacific Rim. From the earthy, smoky flavors of the Maori hāngī to the iconic sweetness of pavlova, New Zealand''s culinary scene is an adventure in itself.</p>

<p><strong>Maori Cuisine – The Hāngī</strong></p>
<p>The Maori hāngī is one of the most traditional and unique dishes you can find in New Zealand. A hāngī is a meal cooked in an underground oven, where food such as meats and root vegetables are slow-cooked over hot stones buried in the earth. This method of cooking imparts a deep, smoky flavor to the food, making it tender and rich in flavor. The hāngī is not just about the food, though—it''s also about the experience. The process of preparing and cooking a hāngī is often a communal activity, bringing people together to share in the feast.</p>

<p>When attending a traditional Maori hāngī, visitors are treated to a meal that includes lamb, chicken, pork, and kumara (sweet potatoes), along with other vegetables. The slow cooking process locks in the flavors, resulting in a hearty and flavorful meal. Hāngī is usually served during special occasions or Maori celebrations, such as weddings or birthdays, but many cultural centers and tours offer visitors the chance to experience this unique culinary tradition.</p>

<p><strong>New Zealand Lamb – The World''s Finest</strong></p>
<p>New Zealand is famous for its lamb, which is considered among the best in the world. Thanks to the country''s vast green pastures and mild climate, New Zealand lamb is tender, juicy, and full of flavor. Whether roasted, grilled, or slow-cooked, lamb is a staple in New Zealand cuisine. A traditional Sunday roast with lamb, mint sauce, and seasonal vegetables is a must-try for anyone visiting the country.</p>

<p>One of the most iconic ways to enjoy New Zealand lamb is with a traditional Kiwi roast. A leg of lamb, seasoned with rosemary, garlic, and olive oil, is slow-roasted to perfection and served with sides such as roasted kumara, potatoes, and gravy. This meal is often enjoyed as a Sunday family tradition, bringing people together to enjoy good food and good company.</p>

<p><strong>Seafood – From Crayfish to Green-Lipped Mussels</strong></p>
<p>With over 15,000 kilometers of coastline, it''s no surprise that New Zealand offers some of the best seafood in the world. The country''s waters are teeming with fresh, sustainable seafood, from crayfish (rock lobster) to green-lipped mussels, which are unique to New Zealand.</p>

<p>Kaikoura, located on the South Island''s east coast, is famous for its crayfish. Many restaurants in the area serve freshly caught crayfish, grilled to perfection and served with butter and lemon. It''s a simple yet incredibly delicious dish that highlights the freshness of the seafood. For those who prefer shellfish, New Zealand''s green-lipped mussels are a must-try. These large, juicy mussels are often steamed or grilled, and served with garlic butter or a tangy tomato-based sauce.</p>

<p><strong>Pavlova – New Zealand''s Favorite Dessert</strong></p>
<p>No culinary tour of New Zealand would be complete without a slice of pavlova. This light, meringue-based dessert is a Kiwi favorite and is often served during special occasions and holidays. The meringue has a crisp crust and a soft, marshmallow-like center, and is usually topped with fresh fruit such as kiwi, strawberries, or passionfruit, along with whipped cream.</p>

<p>The origin of pavlova has long been debated between Australia and New Zealand, with both countries claiming to have invented the dessert. However, New Zealanders are adamant that pavlova is their creation, and it remains one of the country''s most beloved dishes.</p>

<p><strong>Modern Kiwi Cuisine – A Fusion of Flavors</strong></p>
<p>In recent years, New Zealand has developed a reputation for its innovative, modern cuisine, which blends traditional flavors with international influences. The country''s chefs are known for their creativity, often using local, seasonal ingredients to create dishes that reflect the country''s diverse culture and natural bounty.</p>

<p>In cities like Auckland and Wellington, you''ll find an array of restaurants serving everything from Pacific Rim cuisine to European-inspired dishes. Many chefs in New Zealand embrace a "farm-to-table" philosophy, ensuring that the ingredients used are as fresh and locally sourced as possible. This dedication to quality is evident in every bite.</p>

<p>In conclusion, New Zealand''s culinary scene offers something for every palate. Whether you''re enjoying a traditional Maori hāngī, indulging in fresh seafood by the coast, or savoring a slice of pavlova, you''ll find that the food in New Zealand is as diverse and delicious as the landscapes that inspire it.</p>',
        '2023-07-01', '2023-07-01', 4, '3');

-- Insert article 2 of user 3:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/nz_wildlife.jpg', 'The Unique Wildlife of New Zealand: A Naturalist''s Paradise',
        '<p>New Zealand is often referred to as a naturalist''s paradise, and for good reason. Its geographical isolation for millions of years has resulted in a unique ecosystem that is home to many species of plants and animals found nowhere else on earth. From the iconic kiwi bird to the playful Hector''s dolphin, New Zealand offers visitors the opportunity to encounter some of the rarest and most fascinating wildlife in the world.</p>

<p><strong>The Kiwi – A National Icon</strong></p>
<p>The kiwi bird is perhaps the most famous of New Zealand''s native species. This flightless bird, with its long beak and small, round body, has become a symbol of the country. Kiwis are nocturnal creatures and are rarely seen in the wild, but several conservation centers around the country offer visitors the chance to see these unique birds up close.</p>

<p>Kiwis are endangered, with habitat loss and introduced predators such as stoats and cats being their primary threats. Conservation efforts are underway to protect these birds, and many New Zealanders are passionate about ensuring the survival of their national icon.</p>

<p><strong>Hector''s Dolphin – The World''s Smallest Dolphin</strong></p>
<p>New Zealand is home to the world''s smallest and rarest dolphin species, the Hector''s dolphin. These playful creatures are found only in the waters around New Zealand, particularly along the South Island''s west coast. Hector''s dolphins are easily recognizable by their rounded dorsal fins and distinctive black-and-white markings.</p>

<p>Visitors to New Zealand can take boat tours to see these dolphins in their natural habitat. The town of Akaroa, located on the Banks Peninsula, is one of the best places to see Hector''s dolphins, and many tours offer the chance to swim with these friendly animals.</p>

<p><strong>The Kakapo – The World''s Largest Parrot</strong></p>
<p>The kakapo is another of New Zealand''s unique and endangered species. This flightless parrot is the largest parrot in the world, and it''s known for its distinctive, owl-like face and green, mossy feathers. The kakapo is critically endangered, with fewer than 200 individuals remaining, but conservation efforts are making progress in protecting this remarkable bird.</p>

<p>Kakapos are nocturnal and solitary, and they live in the dense forests of New Zealand''s offshore islands. Conservationists have relocated the remaining kakapos to predator-free sanctuaries in an effort to boost their population. While it''s rare to see a kakapo in the wild, visitors can learn about this fascinating bird at various wildlife centers and sanctuaries across the country.</p>

<p><strong>The Tuatara – A Living Fossil</strong></p>
<p>The tuatara is often referred to as a "living fossil" because it is the only surviving member of an ancient group of reptiles that lived during the age of the dinosaurs. Tuataras are found only in New Zealand, and they are unique in that they have a third eye on the top of their head, which is thought to help regulate their body temperature.</p>

<p>Tuataras are long-lived reptiles, with some individuals living for over 100 years. These ancient creatures can be seen at wildlife sanctuaries such as Zealandia in Wellington, where visitors can learn about their history and the efforts being made to protect them.</p>

<p><strong>New Zealand Fur Seal – Playful Marine Mammals</strong></p>
<p>New Zealand''s coastline is home to colonies of fur seals, particularly along the South Island''s rugged west coast. These playful marine mammals can often be seen lounging on the rocks or swimming in the surf, and they are a delight to watch.</p>

<p>Fur seals were once hunted to the brink of extinction for their pelts, but they have made a remarkable recovery and are now a common sight along New Zealand''s shores. Visitors to places like Kaikoura and the Otago Peninsula can see fur seals up close, often in large colonies.</p>

<p><strong>Conservation in New Zealand</strong></p>
<p>New Zealand is committed to protecting its unique wildlife, and conservation efforts are a top priority. The Department of Conservation (DOC) works tirelessly to protect endangered species and restore their natural habitats. Predator control programs, wildlife sanctuaries, and breeding programs are just a few of the ways New Zealand is working to ensure the survival of its native species.</p>

<p>For visitors, experiencing New Zealand''s wildlife is an unforgettable experience. Whether you''re watching dolphins play in the surf, hearing the call of the kiwi at night, or marveling at the ancient tuatara, you''ll come away with a deeper appreciation for the unique and fragile ecosystems that make New Zealand so special.</p>',
        '2023-07-10', '2023-07-10', 2, '3');

-- Insert article 3 of user 3:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/marlborough_wine.jpg', 'Exploring the Vineyards of Marlborough: New Zealand''s Wine Paradise',
        '<p>Marlborough is New Zealand''s most famous wine region, and it''s internationally renowned for producing some of the best Sauvignon Blanc in the world. Located at the northeastern tip of the South Island, Marlborough''s warm, sunny climate and fertile soil make it the perfect place for growing grapes. The region is home to over 150 wineries, and wine enthusiasts from all over the world come to Marlborough to experience its exceptional wines.</p>

<p><strong>Sauvignon Blanc – The Star of Marlborough</strong></p>
<p>Marlborough is synonymous with Sauvignon Blanc, a variety that has put New Zealand on the global wine map. The region''s unique terroir, characterized by a combination of cool nights and sunny days, allows the grapes to ripen slowly, resulting in wines with intense flavors and high acidity. Marlborough Sauvignon Blanc is known for its vibrant, tropical fruit flavors, with notes of passionfruit, gooseberry, and citrus.</p>

<p>One of the best ways to experience Marlborough''s world-class Sauvignon Blanc is by visiting the many wineries that dot the region. Wineries such as Cloudy Bay, Brancott Estate, and Oyster Bay offer tastings and tours that provide insight into the winemaking process. Visitors can stroll through the vineyards, learn about the history of the region, and, of course, sample some of the best wines New Zealand has to offer.</p>

<p><strong>Other Varietals – Chardonnay, Pinot Noir, and More</strong></p>
<p>While Sauvignon Blanc is the star of Marlborough, the region also produces excellent Chardonnay, Pinot Noir, and sparkling wines. Chardonnay from Marlborough tends to be more restrained and elegant than its counterparts from warmer regions, with flavors of stone fruit, citrus, and a subtle minerality. Many of the region''s winemakers use a combination of oak and stainless steel fermentation to create a balanced, complex Chardonnay that appeals to a wide range of palates.</p>

<p>Pinot Noir is another varietal that has gained popularity in Marlborough. The region''s cool climate is ideal for growing Pinot Noir grapes, and the resulting wines are known for their bright red fruit flavors, silky texture, and elegant structure. Pinot Noir from Marlborough is often described as being lighter and more delicate than Pinot Noir from Central Otago, but it still delivers plenty of depth and complexity.</p>

<p>In addition to still wines, Marlborough is also known for its sparkling wines. Made using the traditional method (the same method used to produce Champagne), Marlborough''s sparkling wines are crisp, refreshing, and perfect for any celebration. Many of the region''s top wineries, including Cloudy Bay and Nautilus Estate, produce excellent sparkling wines that are well worth trying.</p>

<p><strong>A Day in Marlborough – Wine Tours and Tastings</strong></p>
<p>A visit to Marlborough is a must for any wine lover, and the region offers plenty of opportunities to explore its vineyards and wineries. Many visitors opt to take guided wine tours, which offer a convenient way to visit multiple wineries in a single day. These tours often include transportation, tastings, and a knowledgeable guide who can provide insight into the region''s winemaking history and techniques.</p>

<p>For those who prefer a more independent experience, renting a bike and cycling through the vineyards is a popular option. Marlborough''s flat terrain and well-maintained roads make it easy to navigate between wineries, and cycling allows visitors to enjoy the beautiful scenery at their own pace. Along the way, you can stop at various wineries for tastings, or enjoy a leisurely lunch at one of the region''s many vineyard restaurants.</p>

<p><strong>Beyond the Wine – Marlborough''s Scenic Beauty</strong></p>
<p>While Marlborough is best known for its wine, the region''s natural beauty is also a major draw for visitors. The Marlborough Sounds, a network of sheltered bays, inlets, and islands, offer stunning coastal scenery and plenty of opportunities for outdoor activities such as boating, kayaking, and hiking. The Queen Charlotte Track, a popular hiking trail, offers spectacular views of the sounds and is a great way to experience the region''s natural beauty.</p>

<p>In conclusion, Marlborough is a wine lover''s paradise, offering world-class wines, beautiful scenery, and a relaxed, welcoming atmosphere. Whether you''re a fan of Sauvignon Blanc, Chardonnay, or Pinot Noir, you''ll find plenty to love in this stunning region. With its combination of exceptional wines and breathtaking landscapes, Marlborough is a must-visit destination for anyone traveling to New Zealand.</p>',
        '2023-07-15', '2023-07-15', 3, '3');

-- Insert article 1 of user 4:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/coastal_tasman.jpg', 'Hiking New Zealand''s Best Trails: The Abel Tasman Coast Track',
        '<p>New Zealand is a hiker''s paradise, and one of the most beautiful and accessible trails is the Abel Tasman Coast Track. Located at the northern tip of New Zealand''s South Island, this 60-kilometer trail takes hikers through lush forests, along golden sandy beaches, and past dramatic coastal cliffs. The Abel Tasman Coast Track is part of New Zealand''s "Great Walks" series, and it''s easy to see why. The scenery is breathtaking, the weather is generally mild, and the trail is well-maintained, making it perfect for both seasoned hikers and beginners alike.</p>

<p><strong>Wildlife and Nature</strong></p>
<p>The Abel Tasman National Park is home to a wide variety of wildlife, both on land and in the sea. The park''s clear waters are perfect for spotting marine life, and it''s not uncommon to see dolphins playing in the waves or seals sunbathing on the rocks. Little blue penguins, the world''s smallest penguin species, can sometimes be seen swimming near the shore, and if you''re lucky, you might even spot an orca or humpback whale passing through the area.</p>

<p>On land, the park is a haven for birdwatchers. The native tui, bellbird, and fantail are commonly seen flitting through the trees, and the park is also home to the rare South Island robin and kaka. The native bush along the trail is lush and full of life, with towering beech and podocarp trees providing shade and shelter for a variety of plant and animal species. The scent of the native manuka and kanuka trees fills the air, and the forest floor is covered with ferns, mosses, and fungi.</p>

<p><strong>Awaroa Inlet – The Jewel of Abel Tasman</strong></p>
<p>One of the highlights of the Abel Tasman Coast Track is Awaroa Inlet, a wide, shallow estuary that is only accessible at low tide. Crossing the inlet is an adventure in itself, as hikers must carefully time their crossing to avoid being stranded by the incoming tide. The inlet''s crystal-clear waters and golden sands make it a perfect spot for swimming, picnicking, or simply relaxing and taking in the breathtaking scenery.</p>

<p>Awaroa Beach, located on the edge of the inlet, is often referred to as the "paradise of New Zealand," and it''s easy to see why. With its secluded location, stunning views, and pristine natural beauty, Awaroa Beach is a favorite among locals and visitors alike. The beach is also home to one of the park''s most popular campsites, making it an ideal place to spend a night under the stars.</p>

<p><strong>A Relaxed and Accessible Hike</strong></p>
<p>One of the reasons the Abel Tasman Coast Track is so popular is its accessibility. Unlike some of New Zealand''s other Great Walks, which require a certain level of fitness and preparation, the Abel Tasman is relatively easy-going. The trail is well-marked and well-maintained, with gentle gradients and plenty of opportunities to rest along the way. For those who don''t want to carry a heavy pack, water taxis and shuttles are available to transport gear between campsites, allowing hikers to travel light and focus on enjoying the journey.</p>

<p>In addition to hiking and kayaking, the Abel Tasman region offers a range of other activities, including swimming, snorkeling, and paddleboarding. The calm, clear waters of the park''s beaches are perfect for a refreshing dip, and the marine life in the area makes snorkeling a rewarding experience. For those who prefer to stay on dry land, there are plenty of scenic viewpoints and short walks to explore, offering stunning panoramic views of the coastline and surrounding mountains.</p>

<p><strong>A Unique New Zealand Experience</strong></p>
<p>The Abel Tasman Coast Track is more than just a hike – it''s an opportunity to experience the best of New Zealand''s natural beauty. The combination of stunning coastal scenery, abundant wildlife, and a relaxed, welcoming atmosphere makes it a must-do for anyone visiting the South Island. Whether you''re a seasoned hiker or just looking for a peaceful escape into nature, the Abel Tasman Coast Track offers something for everyone. So pack your bags, lace up your hiking boots, and get ready to explore one of the most beautiful corners of New Zealand.</p>',
        '2023-07-01', '2023-07-01', 1, '4');

-- Insert article 2 of user 4:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/rotorua_geothermal.jpg', 'New Zealand''s Geothermal Wonderland: Rotorua',
        '<p>Rotorua, located on New Zealand''s North Island, is a place like no other. Known for its geothermal activity, Maori culture, and adventure tourism, Rotorua offers visitors a unique glimpse into the volcanic forces that have shaped the country''s landscape over millions of years. From bubbling mud pools and steaming geysers to relaxing hot springs, Rotorua is a geothermal wonderland that captivates the imagination.</p>

<p><strong>A Land of Fire and Water</strong></p>
<p>Rotorua sits on the Pacific Ring of Fire, a horseshoe-shaped area of the Pacific Ocean basin known for its frequent earthquakes and volcanic activity. The geothermal energy beneath Rotorua''s surface powers geysers, hot springs, and mud pools, making the town a haven for those seeking to experience the raw power of nature. The most famous of Rotorua''s geothermal attractions is <strong>Te Puia</strong>, home to the <strong>Pohutu Geyser</strong>, the largest active geyser in the Southern Hemisphere. Pohutu erupts multiple times a day, shooting boiling water up to 30 meters into the air, and it''s a sight that never fails to impress.</p>

<p>Another must-see geothermal attraction is the <strong>Wai-O-Tapu Thermal Wonderland</strong>, known for its colorful hot springs and steaming craters. One of the park''s most famous features is the <strong>Champagne Pool</strong>, a hot spring with bright orange and green colors caused by the high levels of minerals in the water. The nearby <strong>Devil''s Bath</strong> is another colorful highlight, with its neon green water making it look like something from another planet. Visitors to Wai-O-Tapu can also witness the daily eruption of the <strong>Lady Knox Geyser</strong>, which reaches heights of up to 20 meters.</p>

<p><strong>Relaxing in the Hot Springs</strong></p>
<p>After a day of exploring Rotorua''s geothermal attractions, there''s no better way to relax than by soaking in one of the area''s natural hot springs. Rotorua is home to several geothermal spas, where visitors can bathe in mineral-rich waters believed to have therapeutic properties. The <strong>Polynesian Spa</strong> is one of the most popular spots for a relaxing soak, offering a range of pools with varying temperatures, all set against the backdrop of Lake Rotorua.</p>

<p>For those looking for a more rustic experience, the <strong>Kerosene Creek</strong> is a natural hot spring located in a riverbed just outside of Rotorua. Visitors can relax in the warm, flowing water while surrounded by native bush, making it a peaceful and serene escape from the busier tourist spots.</p>

<p><strong>Maori Culture in Rotorua</strong></p>
<p>Rotorua is also a center of Maori culture, and visitors to the area have the opportunity to learn about New Zealand''s indigenous people through performances, tours, and traditional feasts. One of the best ways to experience Maori culture is by visiting a marae (Maori meeting house) and attending a traditional <strong>hangi</strong> dinner. A hangi is a meal cooked in an underground oven using heated rocks, and it''s a cornerstone of Maori hospitality. The meal typically includes lamb, chicken, kumara (sweet potatoes), and other vegetables, all cooked to tender perfection. As part of the experience, guests are treated to a <strong>haka</strong> performance – a traditional Maori war dance that is both powerful and emotional.</p>

<p>At the <strong>Tamaki Maori Village</strong>, visitors can take part in a cultural evening that includes a tour of the village, a hangi feast, and a performance of traditional Maori music and dance. The experience provides a fascinating insight into the Maori way of life and their deep connection to the land and its geothermal energy.</p>

<p><strong>Adventure Tourism in Rotorua</strong></p>
<p>In addition to its geothermal and cultural attractions, Rotorua is a hub for adventure tourism. The surrounding area offers a range of activities for thrill-seekers, from mountain biking and zip-lining to white-water rafting and zorbing. <strong>Zorbing</strong>, which was invented in Rotorua, involves rolling down a hill in a large, transparent inflatable ball – it''s a unique and exhilarating experience that''s not for the faint of heart!</p>

<p>Mountain biking is another popular activity in Rotorua, with the <strong>Redwoods Whakarewarewa Forest</strong> offering some of the best trails in the country. The forest''s towering redwoods provide a stunning backdrop for riders, and the network of trails caters to all skill levels, from beginners to advanced riders.</p>

<p><strong>A Destination Like No Other</strong></p>
<p>Rotorua is a destination that truly has something for everyone. Whether you''re drawn to its geothermal wonders, its rich Maori culture, or its adrenaline-pumping activities, Rotorua offers an experience that is both unique and unforgettable. It''s a place where the forces of nature are on full display, and where the past and present come together in a way that captivates and inspires.</p>',
        '2023-07-10', '2023-07-10', 2, '4');

-- Insert article 3 of user 4:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/lotr_locations.jpg', 'The Lord of the Rings Filming Locations: A Journey Through Middle-Earth',
        '<p>New Zealand is known for its breathtaking landscapes, and nowhere is this more evident than in the locations used to film <strong>The Lord of the Rings</strong> trilogy. Director Peter Jackson chose New Zealand as the primary filming location for the movies, and the country''s diverse terrain perfectly captured the beauty and grandeur of Middle-Earth. Today, fans of the movies can visit many of the filming locations and relive their favorite moments from the films.</p>

<p><strong>Hobbiton – The Shire</strong></p>
<p>No trip to New Zealand for a Lord of the Rings fan would be complete without a visit to <strong>Hobbiton</strong>, the fictional home of the hobbits. Located near the town of Matamata on the North Island, Hobbiton is a fully recreated movie set that visitors can tour. The rolling green hills, quaint hobbit holes, and the iconic <strong>Green Dragon Inn</strong> make it feel as though you''ve stepped straight into Middle-Earth. Visitors can take guided tours of the set, learn about how the movies were made, and even enjoy a drink at the Green Dragon.</p>

<p>Hobbiton was originally built for the filming of the Lord of the Rings trilogy, but it was dismantled after filming was completed. However, when the set was rebuilt for <strong>The Hobbit</strong> movies, it was made permanent, and it has since become one of New Zealand''s most popular tourist attractions.</p>

<p><strong>Mount Doom – Tongariro National Park</strong></p>
<p>The volcanic landscapes of Tongariro National Park were used to depict the fiery realm of <strong>Mordor</strong> in the films, with <strong>Mount Ngauruhoe</strong> serving as the infamous <strong>Mount Doom</strong>. The rugged terrain of the park, with its barren craters, lava flows, and steaming vents, provided the perfect backdrop for the dark and desolate land of Mordor.</p>

<p>Hikers can follow in the footsteps of Frodo and Sam by taking the <strong>Tongariro Alpine Crossing</strong>, a 19.4-kilometer trek that passes by Mount Ngauruhoe and offers stunning views of the surrounding landscape. The hike is challenging, but the reward is worth it – the scenery is some of the most dramatic in New Zealand, and it''s easy to see why it was chosen to represent Mordor.</p>

<p><strong>Edoras – Mount Sunday</strong></p>
<p>In the heart of the South Island''s <strong>Canterbury Plains</strong> lies <strong>Mount Sunday</strong>, the location used to depict <strong>Edoras</strong>, the capital city of <strong>Rohan</strong>. This remote hill, surrounded by snow-capped mountains and wide-open plains, was the perfect spot to bring the kingdom of Rohan to life. While the set built for the films is no longer there, visitors can still hike to the top of Mount Sunday and take in the breathtaking 360-degree views of the surrounding landscape.</p>

<p>For fans of the movies, visiting Mount Sunday is a truly special experience. The sense of isolation and the vast, untamed wilderness of the area perfectly captures the spirit of Rohan, and standing on the top of the hill, it''s easy to imagine the golden hall of Meduseld towering above you.</p>

<p><strong>The Fangorn Forest – Fiordland National Park</strong></p>
<p>The towering beech trees of Fiordland National Park were used to depict <strong>Fangorn Forest</strong>, home to the ancient tree-herders known as the <strong>Ents</strong>. The dense, moss-covered forest, with its twisting branches and dappled sunlight, creates an atmosphere that feels both magical and mysterious. It''s easy to see why this location was chosen to represent the ancient and enchanted forest of Fangorn.</p>

<p>Visitors to Fiordland National Park can explore the forest by taking one of the many walking trails that wind through the trees. The park is also home to <strong>Milford Sound</strong> and <strong>Doubtful Sound</strong>, two of New Zealand''s most stunning fjords, making it a must-visit destination for nature lovers and Lord of the Rings fans alike.</p>

<p><strong>The Pelennor Fields – Twizel</strong></p>
<p>The vast open plains near the town of Twizel, located in the Mackenzie Basin on the South Island, were used to film the epic <strong>Battle of the Pelennor Fields</strong> in <strong>The Return of the King</strong>. The wide, flat landscape, framed by mountains in the distance, provided the perfect setting for one of the most iconic scenes in the trilogy.</p>

<p>Visitors to the area can take guided tours of the filming locations, learning about how the massive battle scenes were filmed and seeing the exact spots where some of the movie''s most memorable moments took place. The stark beauty of the Mackenzie Basin, with its dry grasslands and dramatic mountain views, makes it a fascinating place to explore, even for those who aren''t Lord of the Rings fans.</p>

<p><strong>A Journey Through Middle-Earth</strong></p>
<p>For fans of <strong>The Lord of the Rings</strong>, visiting the filming locations in New Zealand is like stepping into another world. The country''s diverse landscapes, from towering mountains and volcanic craters to lush forests and tranquil lakes, perfectly captured the essence of Middle-Earth. Whether you''re exploring Hobbiton, hiking through Mordor, or standing on the Pelennor Fields, the magic of the movies comes to life in a way that is both unforgettable and awe-inspiring.</p>',
        '2023-07-15', '2023-07-15', 3, '4');

-- Insert article 1 of user 5:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/fiordland.jpg', 'The Enchanting Beauty of Fiordland National Park',
        '<p>Fiordland National Park is one of the most breathtaking natural landscapes in New Zealand, and it is a UNESCO World Heritage site. Located in the southwestern corner of the South Island, Fiordland is known for its stunning fiords, dramatic mountains, and pristine rainforests. The park encompasses some of the most spectacular scenery in the country, attracting adventurers, photographers, and nature lovers from around the world.</p>

<p><strong>A Land of Fiords</strong></p>
<p>Fiordland is home to some of the most famous fiords in the world, including <strong>Milford Sound</strong>, <strong>Doubtful Sound</strong>, and <strong>Bradshaw Sound</strong>. Milford Sound, often referred to as the "eighth wonder of the world," is perhaps the most iconic of all. The steep cliffs that rise dramatically from the dark waters of the fiord, combined with cascading waterfalls and lush rainforests, create an awe-inspiring landscape. The sheer scale of the scenery leaves many visitors speechless.</p>

<p>Exploring Milford Sound by boat is the most popular way to experience its beauty. As you glide through the waters, you''ll see towering peaks, including the famous <strong>Mitre Peak</strong>, which rises 1,692 meters straight out of the sea. During the cruise, keep an eye out for wildlife – dolphins, seals, and even the rare Fiordland crested penguin can often be spotted along the way. The sound is particularly magical during and after rain, as hundreds of temporary waterfalls cascade down the cliffs.</p>

<p><strong>Doubtful Sound – A More Remote Adventure</strong></p>
<p>While Milford Sound attracts the majority of visitors, <strong>Doubtful Sound</strong> offers a more remote and tranquil experience. Accessible only by boat, this vast fiord is often less crowded, allowing visitors to fully immerse themselves in its natural beauty. The journey to Doubtful Sound itself is an adventure, involving a scenic boat ride across <strong>Lake Manapouri</strong> followed by a bus trip over the <strong>Wilmot Pass</strong>.</p>

<p>Doubtful Sound is often referred to as the "sound of silence" due to its serene atmosphere. Here, the dramatic scenery of steep cliffs, lush rainforests, and hidden waterfalls can be enjoyed in peace. Kayaking is a popular activity in Doubtful Sound, providing an intimate way to explore the fiord and get up close to the wildlife that inhabits the area.</p>

<p><strong>Hiking in Fiordland</strong></p>
<p>For those who prefer to explore on foot, Fiordland offers a range of hiking trails suitable for all fitness levels. The <strong>Milford Track</strong>, often dubbed the "finest walk in the world," is a four-day hike that takes you through stunning valleys, past majestic waterfalls, and over alpine passes. Hikers are treated to breathtaking views of the fiord, and the journey culminates at Milford Sound.</p>

<p>Another popular hike is the <strong>Routeburn Track</strong>, which showcases the diverse landscapes of Fiordland National Park. This trail winds through lush forests, alongside rivers, and offers stunning vistas of the surrounding mountains. Both tracks are part of New Zealand''s "Great Walks" and are best enjoyed during the summer months when the weather is milder.</p>

<p><strong>The Natural Environment</strong></p>
<p>Fiordland National Park is not only about stunning scenery but also about its unique ecosystem. The region is home to many species of native flora and fauna, some of which are found nowhere else on earth. The dense rainforests are home to ancient trees such as the <strong>kahikatea</strong> and <strong>rimu</strong>, while the undergrowth is filled with ferns, mosses, and other native plants.</p>

<p>Wildlife enthusiasts will delight in the opportunity to see a variety of bird species, including the endangered <strong>kiwi</strong>, <strong>takahe</strong>, and <strong>kaka</strong>. The park''s diverse habitats provide a home for these unique birds, and conservation efforts are in place to protect their populations.</p>

<p><strong>A Must-Visit Destination</strong></p>
<p>Fiordland National Park is a true natural wonder that should not be missed on any trip to New Zealand. Whether you''re taking a leisurely cruise through Milford Sound, embarking on an epic hike, or simply soaking in the stunning scenery, the beauty of Fiordland will leave a lasting impression on your heart. As you explore this enchanting landscape, you''ll come to appreciate the raw power of nature and the incredible beauty that New Zealand has to offer.</p>',
        '2023-07-01', '2023-07-01', 3, '5');

-- Insert article 2 of user 5:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/queenstown.jpg', 'Adventuring in Queenstown: The Adventure Capital of New Zealand',
        '<p>Queenstown, often referred to as the "Adventure Capital of New Zealand," is a destination that offers a thrilling mix of outdoor activities, stunning scenery, and vibrant culture. Nestled on the shores of <strong>Lake Wakatipu</strong> and surrounded by the majestic <strong>Southern Alps</strong>, Queenstown is a year-round playground for adventure seekers and nature lovers alike.</p>

<p><strong>Outdoor Adventures</strong></p>
<p>From bungee jumping off the historic <strong>Kawarau Bridge</strong> to skydiving over breathtaking landscapes, Queenstown is the ultimate destination for adrenaline junkies. Bungee jumping was pioneered in New Zealand, and the experience of leaping off a bridge with nothing but a cord attached to your ankles is both exhilarating and terrifying. The views from the bridge are stunning, making the jump even more unforgettable.</p>

<p>For those looking for a different kind of thrill, <strong>jet boating</strong> on the Shotover River offers an adrenaline-pumping experience. Jet boats zip through narrow canyons, performing high-speed turns and 360-degree spins, all while skimming just inches above the water. It''s a thrilling way to experience the rugged beauty of the surrounding landscape.</p>

<p><strong>Skiing and Snowboarding</strong></p>
<p>In the winter months, Queenstown transforms into a ski resort, attracting snow enthusiasts from around the globe. The nearby <strong>Remarkables</strong> and <strong>Coronet Peak</strong> ski areas offer excellent skiing and snowboarding opportunities for all skill levels. With well-groomed slopes, stunning views, and a lively après-ski scene, Queenstown is a winter wonderland for both beginners and experts.</p>

<p>For those who prefer a more leisurely experience, the <strong>Glenorchy</strong> road trip is a must-do. This scenic drive leads you along the edge of Lake Wakatipu, with views of the Southern Alps that will leave you breathless. Glenorchy itself is a charming small town and serves as the gateway to the <strong>Routeburn Track</strong>, one of New Zealand''s Great Walks.</p>

<p><strong>Culinary Delights and Nightlife</strong></p>
<p>Queenstown''s vibrant culinary scene is as exciting as its adventure offerings. The town is home to a diverse range of restaurants, cafes, and bars that cater to every taste. Whether you''re in the mood for fine dining or a casual bite, Queenstown has it all. Local ingredients, including lamb, venison, and fresh produce, are highlighted on many menus, ensuring a true taste of New Zealand.</p>

<p>After a day of adventure, the town comes alive with a vibrant nightlife scene. Queenstown offers a variety of bars and clubs where visitors can unwind and socialize with fellow travelers. The lively atmosphere, coupled with live music and entertainment, makes for an unforgettable night out.</p>

<p><strong>Breathtaking Scenery</strong></p>
<p>One of the most remarkable aspects of Queenstown is its stunning scenery. The surrounding landscapes are a photographer''s dream, with dramatic mountains, crystal-clear lakes, and lush forests providing the perfect backdrop for every adventure. A trip on the <strong>TSS Earnslaw</strong>, a vintage steamship, allows visitors to experience the beauty of Lake Wakatipu while enjoying a gourmet barbecue lunch on <strong>Walter Peak</strong>.</p>

<p>For panoramic views of the region, a trip on the <strong>Skyline Gondola</strong> is a must. The gondola ascends to the top of <strong>Bob''s Peak</strong>, offering stunning views of the Remarkables mountain range and the shimmering lake below. At the top, visitors can enjoy a meal at the restaurant or partake in activities such as luge rides or stargazing.</p>

<p><strong>A Destination for All Seasons</strong></p>
<p>Whether you''re seeking adrenaline-fueled adventures, breathtaking scenery, or a relaxing escape, Queenstown has something for everyone. The town''s friendly atmosphere, combined with its incredible natural beauty, makes it a perfect destination for families, couples, and solo travelers alike. Queenstown is a place where adventure and relaxation go hand in hand, allowing visitors to create unforgettable memories against a backdrop of stunning landscapes.</p>

<p>In conclusion, Queenstown is a must-visit destination for anyone traveling to New Zealand. Its reputation as the "Adventure Capital" is well-deserved, and the variety of activities available ensures that there is something for every adventurer. Whether you''re bungee jumping, skiing, or simply enjoying a glass of local wine while taking in the views, Queenstown promises an experience that is both thrilling and breathtaking.</p>',
        '2023-07-10', '2023-07-10', 4, '5');

-- Insert article 3 of user 5:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/south_island_road_trip.jpg', 'The Great New Zealand Road Trip: Exploring the South Island',
        '<p>New Zealand''s South Island is renowned for its breathtaking landscapes, diverse ecosystems, and vibrant cities. One of the best ways to explore this stunning region is by taking a road trip, allowing you to experience its natural beauty at your own pace. From the rugged mountains and fjords of Fiordland to the tranquil lakes and charming towns, a road trip across the South Island is an adventure filled with unforgettable sights and experiences.</p>

<p><strong>Starting in Christchurch</strong></p>
<p>Your journey can begin in <strong>Christchurch</strong>, the largest city on the South Island. Known as the "Garden City," Christchurch is famous for its beautiful parks, gardens, and historic architecture. Take some time to explore the <strong>Botanic Gardens</strong>, where you can stroll through beautifully landscaped gardens and enjoy the vibrant floral displays. The city also has a thriving arts scene, with numerous galleries, theaters, and street art adding to its charm.</p>

<p>From Christchurch, you can head to the stunning <strong>Arthur''s Pass National Park</strong>, where the Southern Alps provide a dramatic backdrop. The park is home to a variety of hiking trails, including the popular <strong>Avalanche Peak</strong> track, which offers breathtaking views of the surrounding mountains and valleys.</p>

<p><strong>Exploring the West Coast</strong></p>
<p>After Arthur''s Pass, continue your journey westward towards the rugged <strong>West Coast</strong>. This remote region is known for its wild landscapes, dense rainforests, and stunning coastline. Stop at <strong>Punakaiki</strong> to see the famous <strong>Pancake Rocks</strong>, a unique geological formation that resembles stacks of pancakes. The blowholes at Punakaiki are particularly impressive during high tide, as waves crash against the rocks and shoot water high into the air.</p>

<p>Further down the coast, visit the charming town of <strong>Hokitika</strong>, known for its beautiful beaches and greenstone (jade) artisans. The nearby <strong>Hokitika Gorge</strong> is a must-visit, with its turquoise waters and lush native bush offering a perfect spot for a picnic and a short hike.</p>

<p><strong>Franz Josef and Fox Glaciers</strong></p>
<p>One of the highlights of the West Coast is the Franz Josef and Fox Glaciers. These magnificent glaciers are among the most accessible in the world and offer a range of activities, from guided walks to helicopter tours. Walking on the glacier is an unforgettable experience, and the stunning ice formations and blue ice caves are truly mesmerizing.</p>

<p>If you''re looking for a different perspective, consider taking a scenic helicopter flight over the glaciers. From the air, you can see the vast ice fields and the surrounding mountains in all their glory. Many tours also include a landing on the glacier itself, giving you the chance to step out and take in the stunning scenery up close.</p>

<p><strong>Queenstown – Adventure Awaits</strong></p>
<p>As you continue your road trip, make your way to <strong>Queenstown</strong>, the adventure capital of New Zealand. Whether you''re looking for adrenaline-pumping activities like bungee jumping, skydiving, or jet boating, or simply want to relax and enjoy the stunning scenery, Queenstown has it all. Take a leisurely stroll along the shores of <strong>Lake Wakatipu</strong>, or ride the <strong>Skyline Gondola</strong> for panoramic views of the region.</p>

<p><strong>Milford Sound – A Scenic Detour</strong></p>
<p>No road trip across the South Island would be complete without a visit to <strong>Milford Sound</strong>. Although it requires a bit of detour from Queenstown, the stunning fjord is well worth the effort. The drive to Milford Sound is one of the most scenic routes in the world, with towering mountains, cascading waterfalls, and lush valleys surrounding you at every turn.</p>

<p>Once you arrive at Milford Sound, take a cruise to fully appreciate the beauty of the fjord. The towering cliffs and waterfalls create a magical atmosphere, and spotting dolphins and seals along the way is a delightful bonus.</p>

<p><strong>Ending in Dunedin</strong></p>
<p>As your road trip comes to an end, consider heading south to <strong>Dunedin</strong>, known for its rich Scottish heritage and stunning architecture. Visit the historic <strong>Dunedin Railway Station</strong>, explore the beautiful <strong>Botanic Garden</strong>, and take a trip to the <strong>Otago Peninsula</strong>, where you can see albatrosses and the rare yellow-eyed penguins in their natural habitat.</p>

<p>In conclusion, a road trip across New Zealand''s South Island is an adventure of a lifetime. With its stunning landscapes, vibrant cities, and diverse ecosystems, the South Island offers something for everyone. Whether you''re hiking in national parks, exploring charming towns, or taking in breathtaking views, each stop along the way adds to the incredible experience. So grab your camera, pack your bags, and hit the road – the beauty of New Zealand awaits!</p>',
        '2023-07-15', '2023-07-15', 2, '5');

-- Insert article 1 of user 6:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/waitomo_caves.jpg', 'The Wonders of the Waitomo Glowworm Caves',
        '<p>Located on New Zealand''s North Island, the <strong>Waitomo Glowworm Caves</strong> are a mesmerizing underground wonderland that draws visitors from around the globe. Renowned for their enchanting glowworms, these caves offer a unique experience that combines stunning geology, rich history, and a touch of magic. Exploring the Waitomo Caves is a journey into the heart of New Zealand''s natural beauty, where the wonders of nature come alive in an extraordinary way.</p>

<p><strong>A Journey Underground</strong></p>
<p>The adventure begins with a guided tour into the caves, where visitors are greeted by the cool, damp air and the stunning limestone formations that have been shaped by millions of years of erosion. The caves are filled with stalactites, stalagmites, and delicate formations that sparkle in the light, creating a fairy-tale atmosphere. As you make your way deeper into the caves, your guide will share stories about the history of the caves, their geological significance, and the fascinating glowworms that inhabit them.</p>

<p>The highlight of the tour is the moment when visitors board a small boat and glide silently through the underground river. As you drift along, the ceiling of the cave opens up to reveal a starry sky of glowing blue-green lights—these are the glowworms, tiny larvae that emit a bioluminescent glow to attract their prey. The sight is both awe-inspiring and serene, making it a truly unforgettable experience.</p>

<p><strong>The Life Cycle of Glowworms</strong></p>
<p>Glowworms are the larval stage of a type of beetle known as <strong>Arachnocampa luminosa</strong>, and their glow is a result of a chemical reaction in their bodies. The larvae hang silk threads from the cave ceiling, which are covered in a sticky substance to trap insects. As the insects are attracted to the glow and get caught in the threads, the glowworms feast on their catch. The glow not only serves as a lure but also helps the larvae to camouflage themselves from potential predators.</p>

<p>The lifecycle of the glowworm includes several stages, from egg to larva to pupa, and finally to adult. The adult glowworm emerges from its pupal stage after about 6 to 12 months, but it does not eat as an adult, focusing instead on reproduction. The glowworm larvae can live for several months to years, depending on environmental conditions, making their light shows a mesmerizing aspect of the caves.</p>

<p><strong>Beyond the Glowworms</strong></p>
<p>While the glowworms are the main attraction, the Waitomo Caves offer more than just their luminous residents. Visitors can also explore the other caves in the area, such as <strong>Ruakuri Cave</strong> and <strong>Aranui Cave</strong>, both of which feature stunning formations, rich Maori history, and diverse wildlife. Ruakuri Cave, in particular, is known for its unique spiral entrance and extensive limestone formations.</p>

<p>For those seeking adventure, <strong>black water rafting</strong> is a popular activity in the Waitomo region. This thrilling experience involves floating through the caves on an inner tube, navigating through underground rivers, and taking in the stunning scenery illuminated by glowworms. It''s a fun and exciting way to experience the caves and is suitable for adventurers of all skill levels.</p>

<p><strong>Cultural Significance</strong></p>
<p>The Waitomo Caves hold cultural significance for the local Maori people, who have a rich history and connection to the land. The name "Waitomo" translates to "water hole," reflecting the importance of water sources in Maori culture. The caves have been a place of exploration and spiritual significance for generations, and many local guides are of Maori descent, offering visitors a unique perspective on the cultural history of the area.</p>

<p><strong>Conclusion</strong></p>
<p>A visit to the Waitomo Glowworm Caves is a must-do for anyone traveling to New Zealand. The combination of stunning natural beauty, fascinating geological formations, and the enchanting glow of the glowworms creates an unforgettable experience. Whether you''re an adventure seeker, a nature lover, or someone simply looking to connect with New Zealand''s unique landscapes, the Waitomo Caves offer something for everyone. Prepare to be amazed by the wonders of this natural marvel and leave with memories that will last a lifetime.</p>',
        '2023-07-01', '2023-07-01', 1, '6');

-- Insert article 2 of user 6:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/bay_of_islands.jpg', 'Discovering the Magic of the Bay of Islands',
        '<p>The <strong>Bay of Islands</strong> is one of New Zealand''s most picturesque destinations, located in the Northland region. Renowned for its stunning natural beauty, crystal-clear waters, and abundant marine life, the Bay of Islands is a haven for adventure seekers, nature lovers, and anyone looking to relax and unwind in a paradise-like setting.</p>

<p><strong>A Maritime Wonderland</strong></p>
<p>The Bay of Islands is made up of over 140 islands, and its waters are dotted with beautiful beaches, secluded coves, and charming towns. The area is a popular spot for sailing, kayaking, and fishing, making it an ideal destination for water enthusiasts. Many visitors choose to take boat tours to explore the islands and enjoy activities such as dolphin watching, snorkeling, and scuba diving.</p>

<p>One of the best ways to experience the Bay of Islands is by taking a sailing trip. Visitors can hop on a sailboat and spend the day cruising the clear waters, stopping at various islands for swimming, picnicking, and exploring. The calm waters of the bay make it perfect for a relaxing day on the water, and the stunning views of the islands and coastline are simply breathtaking.</p>

<p><strong>Dolphin Watching</strong></p>
<p>The Bay of Islands is also famous for its resident pod of dolphins. Taking a boat tour for dolphin watching is a highlight for many visitors. You can see these playful creatures swimming alongside the boat, and in some tours, you may even have the opportunity to swim with dolphins in their natural habitat. Watching them leap and play in the water is a magical experience that adds a touch of wonder to your visit.</p>

<p><strong>Historical Significance</strong></p>
<p>The Bay of Islands is not only known for its natural beauty but also for its rich history. It was one of the first areas in New Zealand to be settled by Europeans, and it played a significant role in the country''s early history. The historic town of <strong>Russell</strong>, once known as Okiato, was the first capital of New Zealand and is filled with charming colonial architecture and interesting historical sites.</p>

<p>The <strong>Waitangi Treaty Grounds</strong>, located just a short drive from Paihia, is another must-visit historical site. It is the location where the Treaty of Waitangi was signed in 1840, marking the beginning of the relationship between the British Crown and the Maori people. Visitors can explore the museum, see the ceremonial waka (war canoe), and learn about the significance of the treaty and its impact on New Zealand''s history.</p>

<p><strong>Beach Bliss</strong></p>
<p>The Bay of Islands is also home to some of New Zealand''s most beautiful beaches. <strong>Paihia Beach</strong> is a popular spot for swimming and relaxing, while <strong>Long Beach</strong> is known for its stunning white sands and tranquil waters. For those looking to escape the crowds, the secluded <strong>Oke Bay</strong> on <strong>Urupukapuka Island</strong> is a hidden gem that offers a peaceful retreat and excellent snorkeling opportunities.</p>

<p>For adventurous spirits, the nearby <strong>Hole in the Rock</strong> is a must-see. This natural rock formation is located at the entrance of <strong>Piercy Island</strong> and is famous for the boat tours that take visitors through the rock arch. The surrounding waters are teeming with marine life, and the stunning scenery makes for fantastic photo opportunities.</p>

<p><strong>Culinary Delights</strong></p>
<p>After a day of exploring the Bay of Islands, indulge in some of the local culinary delights. The area is known for its fresh seafood, with local restaurants offering everything from fish and chips to gourmet seafood dishes. Enjoying a meal overlooking the bay as the sun sets is a perfect way to end your day.</p>

<p><strong>Conclusion</strong></p>
<p>The Bay of Islands is a destination that offers a unique blend of adventure, history, and natural beauty. Whether you''re sailing through the islands, swimming with dolphins, or soaking in the rich culture of the area, the Bay of Islands promises an unforgettable experience. It''s a place where you can connect with nature, explore the past, and create lasting memories in one of New Zealand''s most stunning regions.</p>',
        '2023-07-10', '2023-07-10', 2, '6');

-- Insert article 3 of user 6:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/south_island_trip.jpg', 'The Wonders of the South Island: A Road Trip Through Scenic Beauty',
        '<p>New Zealand''s South Island is renowned for its breathtaking landscapes, making it a popular destination for travelers seeking adventure and natural beauty. A road trip through the South Island is one of the best ways to experience its stunning scenery, from the snow-capped peaks of the Southern Alps to the pristine lakes and lush vineyards. Each stop along the way offers something unique, creating an unforgettable journey.</p>

<p><strong>Starting Point: Christchurch</strong></p>
<p>Your adventure can begin in <strong>Christchurch</strong>, the largest city on the South Island. Known for its beautiful gardens and vibrant arts scene, Christchurch is often referred to as the "Garden City." Visit the stunning <strong>Botanic Gardens</strong>, where you can wander through beautifully landscaped gardens filled with native plants and colorful flowers. The <strong>Christchurch Art Gallery</strong> is also worth a visit, showcasing an impressive collection of contemporary art.</p>

<p>From Christchurch, you can drive westward towards the <strong>Arthur''s Pass National Park</strong>, a scenic route that takes you through the heart of the Southern Alps. This area is popular for hiking, with numerous trails that offer stunning views of the mountains, valleys, and rivers.</p>

<p><strong>Fiordland National Park</strong></p>
<p>As you continue your journey, make your way to <strong>Fiordland National Park</strong>, one of New Zealand''s most iconic destinations. The park is home to the famous <strong>Milford Sound</strong> and <strong>Doubtful Sound</strong>, where visitors can take boat tours to witness the dramatic landscapes and cascading waterfalls. The fiords are surrounded by steep cliffs and lush rainforests, creating a breathtaking setting that is often shrouded in mist.</p>

<p>For those seeking adventure, the <strong>Milford Track</strong> is a must-do. This multi-day hike takes you through stunning valleys, past towering waterfalls, and offers breathtaking views of the surrounding peaks. Hiking the Milford Track is an unforgettable experience and allows you to connect with New Zealand''s untouched wilderness.</p>

<p><strong>Queenstown – The Adventure Capital</strong></p>
<p>After exploring Fiordland, head to <strong>Queenstown</strong>, known as the "Adventure Capital of New Zealand." This vibrant town is surrounded by mountains and is situated on the shores of <strong>Lake Wakatipu</strong>. In Queenstown, you can try your hand at bungee jumping, skydiving, or jet boating, or simply enjoy the stunning views from the Skyline Gondola.</p>

<p>The nearby <strong>Remarkables</strong> and <strong>Coronet Peak</strong> offer excellent skiing and snowboarding opportunities during the winter months, making Queenstown a year-round destination for adventure enthusiasts.</p>

<p><strong>Marlborough Wine Region</strong></p>
<p>As you continue your road trip, make a stop in the <strong>Marlborough</strong> wine region, famous for its world-class Sauvignon Blanc. Take a wine tour to visit some of the region''s top wineries, where you can sample the delicious wines and learn about the winemaking process. The picturesque vineyards set against the backdrop of the mountains make for a perfect photo opportunity.</p>

<p><strong>Kaikoura – Marine Wildlife</strong></p>
<p>Before concluding your road trip, don''t miss a visit to <strong>Kaikoura</strong>, known for its marine wildlife and stunning coastal scenery. Go whale watching and keep an eye out for the giant sperm whales that frequent the area, as well as dolphins and seals. Kaikoura is also home to some of New Zealand''s freshest seafood, making it a great place to enjoy a meal with a view.</p>

<p><strong>Ending in Christchurch</strong></p>
<p>Finally, make your way back to Christchurch to complete your journey. Take the scenic route along the <strong>Southern Alps</strong>, stopping at picturesque towns along the way, such as <strong>Geraldine</strong> and <strong>Ashburton</strong>. Once back in Christchurch, reflect on the incredible experiences you''ve had during your road trip through the South Island.</p>

<p><strong>Conclusion</strong></p>
<p>A road trip through New Zealand''s South Island is a journey of a lifetime. With its stunning landscapes, rich culture, and thrilling adventures, the South Island offers something for everyone. Whether you''re hiking in Fiordland, tasting world-class wines in Marlborough, or enjoying the vibrant atmosphere of Queenstown, each stop along the way adds to the incredible experience. Pack your bags, hit the road, and prepare for an adventure that will create memories to last a lifetime.</p>',
        '2023-07-15', '2023-07-15', 3, '6');

-- Insert article 1 of user 7:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/tongariro_national_park.jpg', 'Unraveling the Beauty of the Tongariro National Park',
        '<p>Tongariro National Park is one of New Zealand''s most stunning natural treasures, recognized as a UNESCO World Heritage site. Located on the North Island, this park is famous for its diverse landscapes, dramatic volcanic scenery, and rich Maori cultural heritage. The park encompasses a unique combination of geological formations, alpine meadows, and lush forests, making it a haven for outdoor enthusiasts and nature lovers alike.</p>

<p><strong>Volcanic Wonders</strong></p>
<p>At the heart of Tongariro National Park are three active volcanic mountains: <strong>Tongariro</strong>, <strong>Ngauruhoe</strong>, and <strong>Ruapehu</strong>. These majestic peaks are not only strikingly beautiful but also hold significant cultural importance to the local Maori people. <strong>Mount Tongariro</strong> is considered a sacred mountain, and its peaks are dotted with craters, steaming vents, and emerald lakes that create a mesmerizing landscape.</p>

<p>One of the park''s most famous features is the <strong>Tongariro Alpine Crossing</strong>, often regarded as one of the best day hikes in New Zealand. This 19.4-kilometer trek takes hikers through a dramatic volcanic landscape, featuring emerald lakes, vibrant red craters, and stunning views of the surrounding mountains. The trail offers a mix of challenging terrain and breathtaking scenery, making it a must-do for adventure seekers.</p>

<p><strong>Maori Heritage</strong></p>
<p>The area surrounding Tongariro National Park is rich in Maori culture and history. The local iwi (tribe), Ngāti Tūwharetoa, holds deep spiritual connections to the land and mountains. Many guided tours are available that provide insights into the Maori culture, including traditional stories, customs, and practices that have been passed down through generations.</p>

<p>Visitors to the park can learn about the legends associated with the mountains and their significance to the Maori people. Engaging with local guides enhances the experience, providing a deeper understanding of the cultural heritage and the landscape''s spiritual meaning.</p>

<p><strong>Adventure Awaits</strong></p>
<p>In addition to hiking, Tongariro National Park offers a variety of outdoor activities year-round. During the winter months, <strong>Mount Ruapehu</strong> transforms into a popular ski resort, attracting snow enthusiasts from around the country. The mountain features several ski areas, including Whakapapa and Turoa, which offer excellent skiing and snowboarding opportunities.</p>

<p>In the warmer months, the park is ideal for mountain biking, fishing, and rock climbing. The varied terrain and stunning vistas make it a playground for those seeking adventure. The nearby <strong>Whanganui River</strong> also offers kayaking and canoeing opportunities, allowing visitors to explore the serene beauty of the park from a different perspective.</p>

<p><strong>Nature and Wildlife</strong></p>
<p>The diverse ecosystems within Tongariro National Park support a wide range of flora and fauna. The park is home to several unique species of plants and animals, including the endangered <strong>kiwi</strong>, <strong>kākā</strong>, and various native bird species. The lush forests and alpine meadows provide habitats for wildlife, making it a great destination for birdwatching and nature photography.</p>

<p>The park''s varied climate, ranging from alpine conditions to temperate rainforests, allows for a rich diversity of plant life. Visitors can explore lush beech forests, vibrant wildflowers, and stunning volcanic landscapes all within the same area.</p>

<p><strong>Conclusion</strong></p>
<p>Tongariro National Park is a breathtaking destination that showcases the natural beauty of New Zealand. From its stunning volcanic landscapes and rich Maori culture to its diverse ecosystems and outdoor adventures, the park offers an unforgettable experience for all who visit. Whether you''re hiking the Alpine Crossing, skiing on Mount Ruapehu, or simply taking in the stunning scenery, Tongariro National Park is a must-visit for anyone exploring New Zealand.</p>',
        '2023-07-01', '2023-07-01', 2, '7');

-- Insert article 2 of user 7:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/lake_tekapo.jpg', 'The Serene Beauty of Lake Tekapo',
        '<p>Nestled in the heart of the South Island, <strong>Lake Tekapo</strong> is renowned for its stunning turquoise waters, breathtaking mountain scenery, and clear night skies. This picturesque lake is one of the most photographed locations in New Zealand, and it''s easy to see why. From its vibrant colors to its tranquil atmosphere, Lake Tekapo offers visitors a serene escape from the hustle and bustle of everyday life.</p>

<p><strong>A Glacial Marvel</strong></p>
<p>Lake Tekapo is fed by glacial meltwater, which gives the lake its striking turquoise hue. The color is a result of finely ground rock particles, known as <strong>rock flour</strong>, that are carried into the lake by the melting glaciers. The lake''s color changes throughout the day depending on the angle of the sun, creating a beautiful display of blues and greens that are mesmerizing to behold.</p>

<p>Surrounding Lake Tekapo are the <strong>Southern Alps</strong>, which provide a stunning backdrop for the lake''s serene waters. The mountains are often snow-capped, creating a picturesque contrast against the lake''s vibrant color. Visitors can take advantage of the stunning scenery by hiking in the nearby <strong>Mount John</strong> area, where trails lead to breathtaking viewpoints overlooking the lake.</p>

<p><strong>Stargazing in a Dark Sky Reserve</strong></p>
<p>One of the most unique features of Lake Tekapo is its designation as a <strong>Dark Sky Reserve</strong>. The area is recognized for its exceptionally clear night skies, making it one of the best places in the world for stargazing. The lack of light pollution allows visitors to see the Milky Way in all its glory, along with countless stars and constellations.</p>

<p>Visitors to the region can take guided stargazing tours, which provide telescopes and expert guidance for observing celestial wonders. The experience of lying beneath a canopy of stars is truly magical, and it offers a perfect way to connect with the natural beauty of the environment.</p>

<p><strong>Exploring the Area</strong></p>
<p>In addition to its stunning lake and dark skies, Lake Tekapo offers a range of activities for visitors to enjoy. The <strong>Church of the Good Shepherd</strong>, a quaint stone church located on the lake''s edge, is a popular spot for photography and offers stunning views of the lake and mountains. The church is often visited by couples seeking a picturesque location for their wedding photos.</p>

<p>During the summer months, visitors can enjoy outdoor activities such as kayaking, cycling, and hiking. The area around Lake Tekapo features numerous trails for mountain biking and walking, catering to all skill levels. For those who prefer a more leisurely pace, picnicking by the lake or enjoying a meal at a lakeside café are perfect ways to soak in the views.</p>

<p><strong>The Unique Landscape of the Mackenzie Region</strong></p>
<p>Lake Tekapo is part of the <strong>Mackenzie Basin</strong>, a unique landscape characterized by its flat plains, rolling hills, and rugged mountains. The region is also home to several other stunning lakes, including <strong>Lake Pukaki</strong> and <strong>Lake Ohau</strong>, which are worth visiting for their breathtaking views and vibrant colors.</p>

<p>The Mackenzie region is also known for its farming, particularly sheep farming. Visitors can learn about the local agricultural practices and even take a farm tour to see sheep shearing and other traditional farming activities in action.</p>

<p><strong>Conclusion</strong></p>
<p>Lake Tekapo is a true gem of New Zealand, offering a perfect blend of natural beauty, adventure, and tranquility. Whether you''re hiking in the mountains, stargazing under the dark sky, or simply enjoying the stunning views of the lake, Lake Tekapo promises an unforgettable experience. As you explore this picturesque region, you''ll come to appreciate the incredible beauty that New Zealand has to offer.</p>',
        '2023-07-10', '2023-07-10', 3, '7');

-- Insert article 3 of user 7:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/nz_history.jpg', 'New Zealand''s Rich History: A Journey Through Time',
        '<p>New Zealand has a rich and diverse history that is deeply intertwined with its stunning landscapes and unique cultures. From the arrival of the Māori people over a thousand years ago to European settlement and beyond, the story of New Zealand is one of exploration, resilience, and cultural exchange. Understanding this history is essential for appreciating the country''s identity and cultural heritage today.</p>

<p><strong>Māori Heritage and Culture</strong></p>
<p>The Māori people are the indigenous inhabitants of New Zealand, and their arrival in the country is believed to have occurred around the 13th century. The Māori brought with them a rich culture, language, and traditions that are still vibrant today. The Māori worldview is closely connected to the land, sea, and natural environment, and their cultural practices are deeply rooted in their ancestral heritage.</p>

<p>Traditional Māori society was organized around <strong>iwi</strong> (tribes) and <strong>hapū</strong> (sub-tribes), with each group having its own customs and traditions. The Māori language, <strong>te reo Māori</strong>, is an official language of New Zealand and is actively promoted and revitalized in schools and communities across the country.</p>

<p>Māori culture is celebrated through various art forms, including carving, weaving, and performing arts. Visitors to New Zealand have the opportunity to experience Māori culture through cultural performances, traditional feasts, and visits to marae (meeting houses). Engaging with Māori communities provides valuable insights into their history and customs, enhancing the travel experience.</p>

<p><strong>European Settlement and Colonization</strong></p>
<p>The first European to arrive in New Zealand was Dutch explorer <strong>Abel Tasman</strong> in 1642. However, it wasn''t until the late 18th century that European settlers began to arrive in significant numbers, led by British explorer <strong>Captain James Cook</strong>. The arrival of European settlers marked a significant turning point in New Zealand''s history, leading to the establishment of trade, land agreements, and, ultimately, colonization.</p>

<p>The signing of the <strong>Treaty of Waitangi</strong> in 1840 between Māori chiefs and the British Crown is a foundational moment in New Zealand''s history. The treaty aimed to establish a framework for governance and protect Māori rights to their land and resources. However, differing interpretations of the treaty have led to ongoing debates and conflicts regarding land rights and sovereignty, making it a significant topic in contemporary New Zealand.</p>

<p><strong>The Gold Rush Era</strong></p>
<p>The discovery of gold in the 1860s brought a wave of settlers to New Zealand, particularly to the Otago region. The <strong>Otago Gold Rush</strong> attracted thousands of prospectors, leading to rapid population growth and economic development. Towns like <strong>Dunedin</strong> flourished during this time, and the gold rush left a lasting legacy on the country''s landscape and culture.</p>

<p>Today, visitors can explore the remnants of this gold rush era in places like <strong>Arrowtown</strong>, a charming town that has preserved its historic buildings and offers insights into the lives of early settlers. Gold panning experiences are also available, allowing visitors to try their luck at finding gold in the rivers.</p>

<p><strong>Modern New Zealand</strong></p>
<p>New Zealand has evolved significantly over the past century, emerging as a vibrant, multicultural society. The country is known for its progressive values, commitment to environmental sustainability, and dedication to social justice. The modern-day focus on biculturalism aims to recognize and honor the partnership established by the Treaty of Waitangi, promoting understanding and respect between Māori and Pākehā (European New Zealanders).</p>

<p>Today, New Zealand is celebrated for its diverse culture, including its thriving arts scene, culinary innovations, and outdoor lifestyle. The country hosts numerous festivals, cultural events, and arts exhibitions that showcase the talents of its people.</p>

<p><strong>Conclusion</strong></p>
<p>A journey through New Zealand''s history reveals a rich tapestry of cultures, traditions, and experiences that shape the country today. From the Māori heritage that forms the foundation of New Zealand''s identity to the influences of European settlement and modern multiculturalism, understanding this history enriches the travel experience and fosters a deeper appreciation for the diverse landscapes and cultures that define New Zealand. By engaging with the past, visitors can connect with the vibrant present and contribute to the ongoing journey of this beautiful country.</p>',
        '2023-07-15', '2023-07-15', 2, '7');

-- Insert article 1 of user 8:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/south_island_landscapes.jpg', 'The Majestic Landscapes of the South Island',
        '<p>The South Island of New Zealand is renowned for its breathtaking landscapes, offering a diverse range of natural beauty that captivates all who visit. From towering mountains and serene lakes to rugged coastlines and lush forests, the South Island is a paradise for nature lovers and adventure seekers alike. This region is home to some of the most stunning scenery in the world, and exploring its landscapes is an unforgettable experience.</p>

<p><strong>The Southern Alps</strong></p>
<p>At the heart of the South Island lies the <strong>Southern Alps</strong>, a spectacular mountain range that stretches for over 500 kilometers. These majestic peaks are home to New Zealand''s highest mountain, <strong>Aoraki/Mount Cook</strong>, which rises to 3,724 meters. The surrounding area is a mecca for hikers and climbers, offering a range of trails and climbing routes that cater to all skill levels.</p>

<p>One of the best ways to experience the Southern Alps is through the <strong>Hooker Valley Track</strong>, a relatively easy hike that rewards visitors with stunning views of Aoraki and the surrounding glaciers. The trail takes you through lush valleys, past glacial rivers, and ends at the stunning <strong>Hooker Lake</strong>, where you can enjoy a close-up view of the mountain and its surrounding scenery.</p>

<p><strong>Glacial Wonders – Franz Josef and Fox Glaciers</strong></p>
<p>The West Coast of the South Island is home to two of the most accessible glaciers in the world: the <strong>Franz Josef Glacier</strong> and the <strong>Fox Glacier</strong>. These massive rivers of ice descend from the Southern Alps and offer visitors the chance to witness the power of nature up close.</p>

<p>Visitors can take guided glacier walks or helicopter tours to explore these stunning glaciers. Walking on the ice is a unique experience, as you traverse crevasses, ice caves, and blue ice formations. For those looking for adventure, ice climbing is also available, allowing thrill-seekers to scale the icy walls of the glacier.</p>

<p><strong>The Tranquil Lakes</strong></p>
<p>In addition to its mountains, the South Island is home to numerous stunning lakes, each with its own unique charm. <strong>Lake Wakatipu</strong>, located near Queenstown, is famous for its striking blue color and scenic surroundings. The lake is shaped like a Z, and its surface reflects the majestic mountains that rise around it.</p>

<p>Another must-visit lake is <strong>Lake Tekapo</strong>, known for its vibrant turquoise waters and stunning views of the Southern Alps. The area around Lake Tekapo is also designated as a Dark Sky Reserve, making it an ideal spot for stargazing. Visitors can take boat tours or simply relax by the lake, soaking in the beautiful scenery.</p>

<p><strong>The Fiordland National Park</strong></p>
<p>No exploration of the South Island would be complete without a visit to <strong>Fiordland National Park</strong>, home to some of New Zealand''s most iconic landscapes. <strong>Milford Sound</strong> and <strong>Doubtful Sound</strong> are two of the most famous fiords in the world, known for their dramatic cliffs, cascading waterfalls, and pristine waters.</p>

<p>Visitors can take boat tours to explore the fiords, witnessing the stunning scenery and abundant wildlife along the way. The towering cliffs, lush rainforests, and serene waters create a magical atmosphere that feels otherworldly. Kayaking in the fiords is also a popular activity, allowing you to experience the tranquility and beauty of the area up close.</p>

<p><strong>The Remarkable Coastline</strong></p>
<p>The South Island is also home to a stunning coastline, with dramatic cliffs, pristine beaches, and unique geological formations. The <strong>Catlins Coast</strong>, located in the southeastern part of the island, offers rugged beauty and stunning natural attractions, including <strong>Curio Bay</strong> and the <strong>Cathedral Caves</strong>.</p>

<p>Curio Bay is famous for its fossilized forest, which dates back over 180 million years. Visitors can explore the area at low tide and see the fossilized tree stumps embedded in the rock. The nearby Cathedral Caves are another highlight, featuring dramatic arches and stunning rock formations that can be explored during guided tours.</p>

<p><strong>Conclusion</strong></p>
<p>The South Island of New Zealand is a treasure trove of natural beauty, offering breathtaking landscapes, unique geological features, and diverse ecosystems. Whether you''re hiking in the mountains, exploring glaciers, or relaxing by the lakes, the South Island promises an adventure that will leave you in awe of its stunning scenery. As you journey through this remarkable region, you''ll come to appreciate the incredible diversity and beauty that New Zealand has to offer.</p>',
        '2023-07-01', '2023-07-01', 1, '8');

-- Insert article 2 of user 8:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/cuisine.jpg', 'A Culinary Journey Through New Zealand: Flavors and Traditions',
        '<p>New Zealand is not only famous for its stunning landscapes and rich cultural heritage but also for its diverse and delicious cuisine. The culinary scene in New Zealand is a reflection of its multicultural society, with influences from Māori, European, Asian, and Pacific Island cultures. This article takes you on a culinary journey through New Zealand, exploring its traditional dishes, modern culinary innovations, and the importance of local ingredients.</p>

<p><strong>Māori Cuisine – A Cultural Feast</strong></p>
<p>At the heart of New Zealand''s culinary heritage is Māori cuisine, which is deeply rooted in the traditions and customs of the indigenous people. One of the most iconic dishes is <strong>Hāngī</strong>, a traditional Māori method of cooking food in an underground oven. This communal cooking style involves placing meat and vegetables wrapped in leaves in a pit filled with hot stones, allowing the food to cook slowly and absorb the earthy flavors.</p>

<p>Hāngī is often prepared for special occasions, such as weddings and birthdays, and is a celebration of Māori culture and hospitality. When attending a Hāngī, guests are treated to a feast that typically includes lamb, chicken, kumara (sweet potatoes), and seasonal vegetables, all cooked to perfection.</p>

<p><strong>Fresh Seafood Delights</strong></p>
<p>New Zealand''s extensive coastline means that seafood plays a significant role in its culinary landscape. The country is famous for its fresh fish, including snapper, blue cod, and hoki. <strong>Green-lipped mussels</strong>, unique to New Zealand, are a must-try for seafood lovers. These plump mussels are often served steamed or grilled, drizzled with garlic butter or a tangy sauce.</p>

<p><strong>Kina</strong>, or sea urchin, is another delicacy enjoyed by locals. It is often served raw and has a unique flavor that reflects the ocean''s freshness. For those who enjoy fishing, many coastal towns offer opportunities for fishing charters, allowing visitors to catch their own dinner.</p>

<p><strong>Lamb – A Taste of New Zealand</strong></p>
<p>New Zealand is renowned for its high-quality lamb, which is often regarded as some of the best in the world. The country''s lush pastures provide the perfect environment for raising sheep, resulting in tender and flavorful meat. Lamb is commonly featured on menus across the country, prepared in various styles ranging from slow-roasted to grilled.</p>

<p>A traditional New Zealand roast lamb dinner, served with mint sauce and seasonal vegetables, is a beloved meal for many families. It is often enjoyed during Sunday lunches and special occasions, bringing people together to share in good food and company.</p>

<p><strong>Modern Kiwi Cuisine</strong></p>
<p>In recent years, New Zealand''s culinary scene has evolved to embrace a modern approach, combining traditional flavors with international influences. Chefs across the country are experimenting with local ingredients to create innovative dishes that reflect the diversity of New Zealand''s culture.</p>

<p>Farm-to-table dining has become increasingly popular, with many restaurants sourcing ingredients directly from local farmers and producers. This commitment to sustainability and quality is evident in the flavors and freshness of the dishes served.</p>

<p><strong>Wine and Culinary Pairings</strong></p>
<p>New Zealand is also famous for its wine, particularly its Sauvignon Blanc from the <strong>Marlborough</strong> region. Wine tasting tours are a popular activity, allowing visitors to sample a variety of local wines and learn about the winemaking process. Pairing local wines with New Zealand''s culinary delights enhances the dining experience, creating a true celebration of flavor.</p>

<p><strong>Conclusion</strong></p>
<p>New Zealand''s culinary scene is a vibrant tapestry of flavors, traditions, and innovations. From the rich heritage of Māori cuisine to modern interpretations of classic dishes, there is something to delight every palate. Whether you''re enjoying a traditional hāngī, savoring fresh seafood, or exploring the world-class wines, New Zealand offers a culinary journey that is as diverse and captivating as its landscapes.</p>',
        '2023-07-10', '2023-07-10', 2, '8');

-- Insert article 3 of user 8:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/rotorua_geothermal.jpg', 'Exploring the Heart of New Zealand: Rotorua''s Geothermal Wonders',
        '<p>Rotorua is one of New Zealand''s most famous destinations, known for its stunning geothermal landscapes, rich Māori culture, and outdoor adventures. Located on the North Island, Rotorua is situated in a volcanic region characterized by bubbling mud pools, steaming geysers, and natural hot springs. This geothermal wonderland offers visitors a unique opportunity to explore the fascinating forces of nature at work.</p>

<p><strong>Geothermal Activity</strong></p>
<p>Rotorua is renowned for its geothermal activity, with several key attractions that showcase the region''s unique geological features. <strong>Te Puia</strong>, home to the famous <strong>Pohutu Geyser</strong>, is a must-visit. Pohutu erupts several times a day, shooting boiling water up to 30 meters into the air, creating a dramatic display that draws visitors from around the world.</p>

<p>In addition to geysers, Rotorua is home to numerous hot springs, which are believed to have therapeutic properties. The <strong>Polynesian Spa</strong> is a popular destination for visitors looking to relax and unwind in mineral-rich waters. With a range of pools, from tranquil lagoons to therapeutic waters, the spa provides a perfect setting to soak in the natural beauty of the area.</p>

<p><strong>Cultural Experiences</strong></p>
<p>Rotorua is also a hub for Māori culture, and visitors have the opportunity to engage with the local Māori community and learn about their rich traditions and history. A visit to a traditional <strong>marae</strong> (meeting house) offers insights into Māori customs, art, and performances. One of the highlights of experiencing Māori culture is attending a <strong>hangi</strong>, a traditional feast cooked in an underground oven.</p>

<p>The <strong>Tamaki Māori Village</strong> provides an immersive cultural experience where visitors can participate in cultural performances, storytelling, and enjoy a delicious hangi dinner. Engaging with the local Māori community allows visitors to gain a deeper understanding of the customs, beliefs, and values that shape the culture of New Zealand.</p>

<p><strong>Adventure Activities</strong></p>
<p>In addition to its geothermal wonders and cultural experiences, Rotorua offers a range of adventure activities for thrill-seekers. The region is known for its mountain biking trails, with the <strong>Redwoods Forest</strong> providing an extensive network of tracks for riders of all skill levels. The forest is renowned for its towering redwood trees and breathtaking scenery, making it a favorite among outdoor enthusiasts.</p>

<p>For those looking for a unique experience, <strong>zorbing</strong> is a popular activity in Rotorua. This exhilarating adventure involves rolling down a hill inside a giant inflatable ball, providing a fun and memorable experience that is unique to New Zealand.</p>

<p><strong>Nature and Wildlife</strong></p>
<p>Rotorua is not only known for its geothermal activity but also for its stunning natural landscapes and wildlife. The nearby <strong>Redwood Forest</strong> offers walking and biking trails that showcase the beauty of the native bush. The towering redwoods create a magical atmosphere, and the forest is home to various bird species, making it a great spot for birdwatching.</p>

<p>The <strong>Lake Rotorua</strong> area is perfect for those seeking outdoor activities such as fishing, kayaking, and walking along the scenic shores. The lake''s calm waters provide a tranquil setting for a relaxing day out, and the surrounding scenery is simply stunning.</p>

<p><strong>Conclusion</strong></p>
<p>Rotorua is a destination that captivates visitors with its geothermal wonders, rich cultural heritage, and outdoor adventures. Whether you''re exploring the bubbling mud pools, engaging with Māori culture, or embarking on an adrenaline-filled adventure, Rotorua offers a diverse range of experiences that showcase the beauty of New Zealand. It''s a place where nature and culture come together, creating unforgettable memories for all who visit.</p>',
        '2023-07-15', '2023-07-15', 3, '8');

-- Insert article 1 of admin 1:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/wellington.jpg', 'Exploring the Vibrant Culture of Wellington',
        '<p>Wellington, the capital city of New Zealand, is known for its vibrant arts scene, rich history, and stunning waterfront. Nestled between the rugged hills and the shores of <strong>Wellington Harbour</strong>, this dynamic city is a cultural hub that offers visitors a diverse range of experiences, from art galleries and museums to lively festivals and delicious cuisine.</p>

<p><strong>A City of Arts</strong></p>
<p>Wellington is often referred to as the "Coolest Little Capital in the World," and for good reason. The city has a thriving arts community, with numerous galleries and studios showcasing the work of local artists. The <strong>Te Papa Tongarewa</strong>, New Zealand''s national museum, is a must-visit for anyone interested in the country''s culture, history, and natural environment. The museum features interactive exhibits, stunning displays of Māori art, and collections that highlight New Zealand''s unique wildlife.</p>

<p>In addition to Te Papa, the city is home to many smaller galleries, such as the <strong>City Gallery Wellington</strong>, which hosts contemporary art exhibitions and installations. The vibrant street art scene adds an extra layer of creativity to the city, with colorful murals and installations adorning walls throughout the central business district.</p>

<p><strong>Culinary Delights</strong></p>
<p>Wellington is also known for its diverse culinary scene, with an array of cafes, restaurants, and food markets that cater to all tastes. The city''s coffee culture is particularly strong, with a plethora of cafes serving up some of the best brews in the country. A visit to Wellington wouldn''t be complete without trying a flat white, a popular coffee drink that originated in New Zealand and Australia.</p>

<p>The <strong>Wellington Waterfront</strong> is a great place to explore local eateries, with numerous food trucks and restaurants offering fresh seafood, international cuisine, and delicious desserts. For a unique dining experience, consider trying one of the city''s many craft breweries, where you can sample locally brewed beers paired with tasty pub fare.</p>

<p><strong>Festivals and Events</strong></p>
<p>Wellington hosts a range of festivals and events throughout the year, showcasing the city''s cultural diversity and creativity. The <strong>Wellington Jazz Festival</strong>, held annually, attracts music lovers from all over the country, featuring local and international jazz musicians in various venues across the city.</p>

<p>Another highlight is the <strong>Wellington International Film Festival</strong>, which showcases a selection of the best films from around the world. The festival draws filmmakers, actors, and cinema enthusiasts, turning the city into a vibrant hub of creativity and expression.</p>

<p><strong>Natural Beauty</strong></p>
<p>Beyond its cultural offerings, Wellington is surrounded by stunning natural landscapes. The <strong>Mount Victoria Lookout</strong> offers panoramic views of the city, harbour, and surrounding hills, making it a popular spot for both tourists and locals. The short hike to the lookout is rewarding, providing breathtaking vistas that capture the essence of Wellington.</p>

<p>The <strong>Wellington Botanic Garden</strong> is another must-visit destination, featuring beautifully landscaped gardens, walking trails, and a variety of native and exotic plants. It''s a perfect place to relax and enjoy the tranquility of nature in the heart of the city.</p>

<p><strong>Conclusion</strong></p>
<p>Wellington is a city that beautifully blends culture, history, and natural beauty. Whether you''re exploring its vibrant arts scene, savoring delicious cuisine, or taking in the stunning views from the hills, Wellington offers a unique experience that reflects the heart and soul of New Zealand. It''s a destination that invites visitors to immerse themselves in its rich culture while enjoying the breathtaking landscapes that surround it.</p>',
        '2023-07-01', '2023-07-01', 1, '9');

-- Insert article 2 of admin 1:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/coromandel_peninsula.jpg', 'The Enchanting Landscapes of the Coromandel Peninsula',
        '<p>The <strong>Coromandel Peninsula</strong> is one of New Zealand''s most beautiful regions, known for its stunning beaches, lush forests, and breathtaking coastal scenery. Located on the North Island, the Coromandel offers a diverse range of outdoor activities, making it a popular destination for travelers seeking adventure and relaxation.</p>

<p><strong>Stunning Beaches</strong></p>
<p>The peninsula is famous for its pristine beaches, with some of the most popular being <strong>Hot Water Beach</strong> and <strong>Cathedral Cove</strong>. Hot Water Beach is unique in that visitors can dig their own hot pools in the sand during low tide, as geothermal springs bubble up from beneath the ground. It''s a truly relaxing experience to soak in your own natural hot pool while overlooking the ocean.</p>

<p>Cathedral Cove is a picturesque spot accessible via a scenic walking track. The iconic rock formations and pristine sands create a stunning backdrop for swimming, kayaking, and picnicking. The area is also known for its clear waters and abundant marine life, making it a great spot for snorkeling and diving.</p>

<p><strong>Hiking Adventures</strong></p>
<p>In addition to its beautiful beaches, the Coromandel Peninsula is home to numerous hiking trails that showcase the region''s stunning landscapes. The <strong>Coromandel Coastal Walkway</strong> is a must-do, offering breathtaking views of the coastline and the chance to spot wildlife such as dolphins and seabirds. The walk takes you along the cliffs, through native bush, and past secluded beaches, providing ample opportunities to enjoy the natural beauty of the area.</p>

<p>For those seeking a more challenging hike, the <strong>Pinnacles Track</strong> is a popular choice. This hike takes you to the summit of the Pinnacles, where you''ll be rewarded with panoramic views of the surrounding landscape. The trail passes through lush forests and ancient kauri trees, offering a glimpse into the region''s unique flora and fauna.</p>

<p><strong>Unique Wildlife</strong></p>
<p>The Coromandel Peninsula is home to a variety of unique wildlife, making it a great destination for nature enthusiasts. The region''s forests are inhabited by native birds such as the tui, kereru (wood pigeon), and the rare kokako. Birdwatching is a popular activity, and visitors can often hear the distinctive songs of these beautiful birds as they hike through the bush.</p>

<p>The waters surrounding the peninsula are also rich in marine life, making it a prime spot for fishing, snorkeling, and diving. Local charters offer opportunities for deep-sea fishing, where you can catch snapper, kingfish, and other delicious seafood.</p>

<p><strong>A Culinary Delight</strong></p>
<p>The Coromandel Peninsula is known for its fresh seafood and delicious local produce. Many restaurants and cafes in the area focus on using local ingredients to create mouthwatering dishes. From fresh fish and chips to gourmet seafood platters, dining in the Coromandel is a treat for the taste buds.</p>

<p>The region is also home to several orchards and farms, producing everything from apples and kiwifruit to avocados and olives. Visitors can explore local markets and farm shops to sample the delicious flavors of the Coromandel, making it a culinary delight for food lovers.</p>

<p><strong>Conclusion</strong></p>
<p>The Coromandel Peninsula is a captivating destination that offers a perfect blend of stunning landscapes, outdoor adventures, and rich culinary experiences. Whether you''re relaxing on the beautiful beaches, hiking through lush forests, or enjoying fresh seafood, the Coromandel is a place that invites visitors to immerse themselves in the beauty of New Zealand. It''s a destination that promises unforgettable memories and a deep appreciation for the natural wonders of the region.</p>',
        '2023-07-10', '2023-07-10', 2, '9');

-- Insert article 3 of admin 1:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/nz_fauna.jpg', 'Discovering New Zealand''s Unique Flora and Fauna',
        '<p>New Zealand is home to a remarkable array of unique flora and fauna that cannot be found anywhere else in the world. The country''s isolation and diverse ecosystems have fostered the evolution of many species, making it a paradise for nature lovers and wildlife enthusiasts. From its ancient forests to its pristine coastlines, New Zealand''s natural heritage is a treasure trove of biodiversity.</p>

<p><strong>Native Birds of New Zealand</strong></p>
<p>One of the most distinctive aspects of New Zealand''s wildlife is its birds. The country is known for its unique avian species, many of which are flightless. The <strong>kiwi</strong>, a symbol of New Zealand, is perhaps the most famous of these birds. This nocturnal, flightless bird is unique to New Zealand and is an iconic part of the country''s culture.</p>

<p>Other notable bird species include the <strong>kākāpō</strong>, a critically endangered flightless parrot, and the <strong>takahe</strong>, a large, colorful bird that was once thought to be extinct. Conservation efforts have been put in place to protect these unique species, and visitors to New Zealand have the opportunity to see them in their natural habitats or at wildlife sanctuaries.</p>

<p><strong>Lush Forests and Plant Life</strong></p>
<p>New Zealand''s forests are a haven for biodiversity, showcasing a wide variety of native plants and trees. The country is home to several unique species of trees, including the ancient <strong>kauri</strong>, which can live for over a thousand years and grow to enormous sizes. The kauri forests are not only stunning to behold but also play a crucial role in the ecosystem, providing habitat for numerous plant and animal species.</p>

<p>Other notable flora includes the <strong>pōhutukawa</strong>, known as the New Zealand Christmas tree due to its vibrant red flowers that bloom in December, and the <strong>harakeke</strong> (flax), which has significant cultural importance to the Maori people. The harakeke is used to create traditional textiles and crafts, showcasing the connection between nature and culture in New Zealand.</p>

<p><strong>Marine Life and Coastal Ecosystems</strong></p>
<p>New Zealand''s coastal waters are rich in marine biodiversity, making it a fantastic destination for snorkeling and diving. The <strong>Poor Knights Islands</strong>, a marine reserve off the Northland coast, is renowned for its crystal-clear waters and diverse marine life. Snorkelers and divers can explore underwater caves, kelp forests, and encounter a variety of fish species, including snapper and blue maomao.</p>

<p>The marine ecosystems surrounding New Zealand also support a range of wildlife, including seals, dolphins, and even whales. The <strong>Kaikoura</strong> region is particularly famous for whale watching, where visitors can see sperm whales and humpback whales in their natural habitat.</p>

<p><strong>Conservation Efforts</strong></p>
<p>New Zealand is dedicated to preserving its unique flora and fauna through various conservation initiatives. Many national parks and reserves have been established to protect native species and their habitats. Organizations and local communities work tirelessly to restore ecosystems, control invasive species, and educate visitors about the importance of conservation.</p>

<p>Visitors to New Zealand are encouraged to engage in responsible tourism practices, such as staying on designated paths, avoiding disturbing wildlife, and supporting local conservation efforts. By doing so, they contribute to the protection of New Zealand''s natural heritage for future generations to enjoy.</p>

<p><strong>Conclusion</strong></p>
<p>New Zealand''s unique flora and fauna are a testament to the country''s rich biodiversity and natural beauty. From the iconic kiwi to the ancient kauri forests, the diverse ecosystems provide a remarkable glimpse into the country''s natural heritage. By exploring the landscapes and engaging with the wildlife, visitors can gain a deeper appreciation for the importance of conservation and the beauty of New Zealand''s unique environment.</p>',
        '2023-07-15', '2023-07-15', 2, '9');

-- Insert article 1 of admin 2:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/fiordlandview.jpg', 'Discovering the Untamed Wilderness of Fiordland',
        '<p>Fiordland National Park is a breathtaking expanse of wilderness located in the southwestern corner of New Zealand. Renowned for its stunning fiords, towering peaks, and lush rainforests, Fiordland is a UNESCO World Heritage site that attracts adventure seekers, nature lovers, and photographers from around the globe. The park encompasses some of the most dramatic landscapes in the country, showcasing the raw beauty of nature at its finest.</p>

<p><strong>The Fiords: Milford Sound and Doubtful Sound</strong></p>
<p>At the heart of Fiordland are the iconic fiords of <strong>Milford Sound</strong> and <strong>Doubtful Sound</strong>. Milford Sound is perhaps the most famous, often described as the "eighth wonder of the world." Its towering cliffs, cascading waterfalls, and deep blue waters create a breathtaking landscape that leaves visitors in awe. Taking a boat cruise through Milford Sound is a must, allowing you to witness the stunning scenery up close and perhaps spot some of the wildlife that inhabits the area.</p>

<p>Doubtful Sound, on the other hand, is known for its tranquility and remoteness. Accessible only by boat, it offers a more secluded experience compared to its more famous counterpart. The journey to Doubtful Sound involves a scenic boat ride across Lake Manapouri followed by a bus ride over Wilmot Pass, providing breathtaking views along the way. Once there, visitors can kayak through the calm waters, explore hidden coves, and take in the serene beauty of the fiord.</p>

<p><strong>The Adventure of Hiking</strong></p>
<p>Fiordland National Park is a hiker''s paradise, with an extensive network of trails that range from easy walks to challenging multi-day hikes. The <strong>Milford Track</strong>, often regarded as one of the finest walks in the world, takes you through stunning valleys, past majestic waterfalls, and over alpine passes. Spanning 53.5 kilometers, this four-day hike rewards trekkers with unparalleled views and an immersive experience in New Zealand''s pristine wilderness.</p>

<p>Another popular hike is the <strong>Routeburn Track</strong>, which traverses the Southern Alps and offers breathtaking views of mountain peaks, lakes, and valleys. This track can be completed as a multi-day hike or enjoyed as a series of day hikes, allowing visitors to experience the beauty of Fiordland at their own pace.</p>

<p><strong>The Unique Flora and Fauna</strong></p>
<p>Fiordland National Park is home to a rich diversity of flora and fauna, many of which are endemic to New Zealand. The dense rainforests are filled with towering rimu and kahikatea trees, while the undergrowth is alive with ferns and mosses. Birdwatchers will delight in the opportunity to spot native species such as the <strong>kiwi</strong>, <strong>takahe</strong>, and <strong>kākā</strong>.</p>

<p>The park''s waterways are equally rich in life, with seals, dolphins, and the occasional penguin spotted in the fjords. The underwater ecosystems are teeming with marine life, making the waters around Fiordland a popular destination for diving and snorkeling.</p>

<p><strong>Cultural Significance</strong></p>
<p>Fiordland also holds cultural significance for the Māori people, who have a deep spiritual connection to the land. The region''s legends and stories are intertwined with the natural landscapes, adding a layer of cultural richness to any visit. Engaging with local Māori guides can enhance your understanding of the cultural heritage of Fiordland and its importance to the indigenous people.</p>

<p><strong>Conclusion</strong></p>
<p>A visit to Fiordland National Park is a journey into the heart of New Zealand''s natural wonders. From the dramatic fiords to the lush rainforests and abundant wildlife, Fiordland offers an adventure that is both exhilarating and serene. Whether you''re hiking the famous tracks, cruising the stunning fiords, or immersing yourself in the rich cultural heritage, Fiordland promises an unforgettable experience that showcases the beauty of New Zealand.</p>',
        '2023-07-01', '2023-07-01', 1, '10');

-- Insert article 2 of admin 2:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/waitomo.jpg', 'The Enchantment of the Waitomo Caves',
        '<p>Located on the North Island, the <strong>Waitomo Caves</strong> are a mesmerizing underground wonderland famous for their stunning glowworms and unique geological features. These caves, formed over millions of years, are a captivating destination for adventurers and nature lovers seeking to explore the hidden wonders beneath the earth''s surface.</p>

<p><strong>The Glowworm Experience</strong></p>
<p>The main attraction of the Waitomo Caves is the incredible display of glowworms, known scientifically as <strong>Arachnocampa luminosa</strong>. These tiny larvae emit a bioluminescent light to attract their prey, creating a magical starry effect on the cave ceilings. Visitors can take guided boat tours through the caves, gliding silently along the underground river as they marvel at the twinkling glowworms above.</p>

<p>As you drift through the darkness, the tranquility of the caves is enhanced by the soft sounds of dripping water and the gentle flow of the river. The experience is both enchanting and serene, offering a glimpse into a hidden world that feels almost otherworldly.</p>

<p><strong>Exploring the Cave System</strong></p>
<p>The Waitomo Caves complex includes several caves, each with its unique features and attractions. <strong>Ruakuri Cave</strong> is known for its stunning limestone formations, impressive waterfalls, and intricate rock structures. The guided tours here provide insights into the geological history of the caves and their significance to the local Maori culture.</p>

<p>Another highlight is <strong>Aranui Cave</strong>, which features impressive stalactites and stalagmites. This cave is less commercialized than others, allowing for a more intimate experience with the natural formations. The enchanting atmosphere and rich history make each cave a fascinating destination in its own right.</p>

<p><strong>The Thrill of Adventure</strong></p>
<p>For those seeking adventure, the Waitomo region offers activities such as black water rafting and abseiling. Black water rafting involves navigating through the caves on an inner tube, experiencing the thrill of rapids while surrounded by stunning geological formations and glowing lights. The adrenaline rush combined with the unique surroundings creates an unforgettable experience.</p>

<p>Abseiling into the depths of the caves allows visitors to descend into the underground world and explore hidden chambers and waterfalls. These activities provide an adventurous way to experience the beauty of the caves while enjoying the natural wonders of the region.</p>

<p><strong>Cultural Significance</strong></p>
<p>The Waitomo Caves also hold cultural significance for the Maori people, who have a deep connection to the land and its natural features. The caves are believed to have spiritual importance, and local guides often share the legends and stories associated with the area. Engaging with the Maori culture adds depth to the visit, allowing visitors to appreciate the historical and spiritual context of the caves.</p>

<p><strong>Conclusion</strong></p>
<p>A visit to the Waitomo Caves is a journey into the magical underground world of New Zealand. The combination of stunning glowworms, impressive geological formations, and rich cultural history creates an enchanting experience for all who venture into the depths of the earth. Whether you''re exploring the caves, indulging in adventure activities, or learning about Maori culture, the Waitomo Caves offer a unique glimpse into the beauty and mystery of New Zealand''s natural heritage.</p>',
        '2023-07-10', '2023-07-10', 1, '10');

-- Insert article 3 of admin 2:
INSERT INTO articles
    (image, title, content, create_date, update_date, likes, userid)
VALUES
    ('images/great_walks.jpg', 'The Allure of New Zealand''s Great Walks',
        '<p>New Zealand is renowned for its stunning landscapes, and what better way to experience them than by embarking on one of the country''s <strong>Great Walks</strong>? These iconic hiking trails showcase the diverse beauty of New Zealand''s natural environment, from majestic mountains and lush forests to pristine lakes and rugged coastlines. The Great Walks offer an unforgettable adventure for hikers of all skill levels, inviting visitors to immerse themselves in the breathtaking scenery and tranquility of nature.</p>

<p><strong>The Milford Track</strong></p>
<p>The <strong>Milford Track</strong> is often regarded as the jewel of New Zealand''s Great Walks. This 53.5-kilometer trail takes hikers through some of the most stunning landscapes in the Fiordland region. Starting at <strong>Glade Wharf</strong>, the trail winds its way through ancient rainforests, alongside crystal-clear rivers, and past spectacular waterfalls, including the famous <strong>Sutherland Falls</strong>, which cascades down from a height of 580 meters.</p>

<p>The trek culminates at <strong>Milford Sound</strong>, where hikers are rewarded with breathtaking views of the towering cliffs and serene waters of the fjord. The Milford Track is typically completed in four days, with well-maintained huts available for overnight stays, allowing hikers to soak in the natural beauty at a leisurely pace.</p>

<p><strong>The Routeburn Track</strong></p>
<p>Another iconic trail is the <strong>Routeburn Track</strong>, which traverses the stunning landscapes of both Fiordland and Mount Aspiring National Parks. This 32-kilometer trail offers hikers a mix of lush forests, alpine meadows, and breathtaking mountain views. The highlight of the Routeburn Track is the <strong>Routeburn Falls</strong>, where hikers can marvel at the cascading water and panoramic views of the surrounding mountains.</p>

<p>The trail can be completed in two to four days, depending on the chosen itinerary, with comfortable huts and campsites along the way. The Routeburn Track is also known for its diverse flora and fauna, with numerous native bird species and unique plant life to observe during the hike.</p>

<p><strong>The Tongariro Alpine Crossing</strong></p>
<p>For those seeking a unique hiking experience, the <strong>Tongariro Alpine Crossing</strong> is a must-try. This 19.4-kilometer trek takes you through a volcanic landscape filled with dramatic craters, emerald lakes, and steaming vents. The crossing offers stunning views of <strong>Mount Ngauruhoe</strong>, also known as <strong>Mount Doom</strong> from the "Lord of the Rings" trilogy, and provides a fascinating insight into the geothermal activity of the region.</p>

<p>The Tongariro Alpine Crossing is typically completed in a single day, making it a popular choice for day hikers. However, the weather can change rapidly, and hikers are advised to come prepared with appropriate gear and clothing.</p>

<p><strong>The Abel Tasman Coast Track</strong></p>
<p>The <strong>Abel Tasman Coast Track</strong> is another iconic Great Walk, known for its stunning coastal scenery and golden sandy beaches. This 60-kilometer trail takes you through the <strong>Abel Tasman National Park</strong>, where you''ll encounter crystal-clear waters, lush forests, and abundant wildlife.</p>

<p>The track is suitable for all skill levels and can be completed in three to five days, with various campsites and huts available for overnight stays. Many visitors choose to combine hiking with kayaking, allowing them to explore the coastline and see the park from a different perspective.</p>

<p><strong>Conclusion</strong></p>
<p>New Zealand''s Great Walks offer an unparalleled opportunity to experience the country''s breathtaking landscapes and diverse ecosystems. Whether you''re hiking the renowned Milford Track, exploring the volcanic wonders of the Tongariro Alpine Crossing, or enjoying the stunning coastal views of the Abel Tasman, each trail provides a unique adventure that showcases the beauty of New Zealand. For those who appreciate nature and seek the thrill of exploration, embarking on one of the Great Walks is an unforgettable experience that will leave lasting memories.</p>',
        '2023-07-15', '2023-07-15', 1, '10');

-- Insert comments for articles
INSERT INTO comments
    (content, create_date, article_id, parent_id, userid)
VALUES
    -- Comments for article 1 of user1
    ('Milford Sound looks breathtaking in your photos!', '2023-07-17', 1, NULL, '1'),
    ('I can’t believe how beautiful the waterfalls are!', '2023-07-18', 1, 1, '3'),
    -- Reply to the first comment
    ('I would love to take a boat cruise there someday!', '2023-07-19', 1, 2, '4'),
    -- Reply to the second comment

    -- Comments for article 2 of user1
    ('The scenery on the Tongariro Alpine Crossing is stunning!', '2023-07-20', 2, NULL, '2'),
    ('I heard the volcanic landscapes are incredible!', '2023-07-21', 2, 1, '3'),
    -- Reply to the first comment
    ('I can’t wait to hike this track next summer!', '2023-07-22', 2, 2, '5'),
    -- Reply to the second comment

    -- Comments for article 3 of user1
    ('The Catlins sounds like a hidden gem!', '2023-07-23', 3, NULL, '6'),
    ('I love the idea of exploring the Cathedral Caves!', '2023-07-24', 3, 1, '7'),
    -- Reply to the first comment
    ('I hope to see the yellow-eyed penguins when I visit!', '2023-07-25', 3, 2, '8'),
    -- Reply to the second comment

    -- Comments for article 1 of user2
    ('I can’t wait to explore those hidden beaches!', '2023-07-26', 4, NULL, '3'),
    ('The beaches you mentioned sound perfect for a getaway!', '2023-07-27', 4, 1, '4'),
    -- Reply to the first comment
    ('I love the idea of finding less crowded spots!', '2023-07-28', 4, 2, '5'),
    -- Reply to the second comment

    -- Comments for article 2 of user2
    ('Rotorua’s geothermal features are so unique!', '2023-07-29', 5, NULL, '1'),
    ('I would love to experience a traditional hangi!', '2023-07-30', 5, 1, '2'),
    -- Reply to the first comment
    ('The mud pools sound fascinating, I must visit!', '2023-07-31', 5, 2, '6'),
    -- Reply to the second comment

    -- Comments for article 3 of user2
    ('The scenic beauty of Rotorua is captivating!', '2023-08-01', 6, NULL, '4'),
    ('I can’t wait to try the adventure activities!', '2023-08-02', 6, 1, '5'),
    -- Reply to the first comment
    ('The Maori culture in Rotorua sounds enriching!', '2023-08-03', 6, 2, '7'),
    -- Reply to the second comment

    -- Comments for article 1 of user3
    ('I love the idea of tasting New Zealand cuisine!', '2023-08-04', 7, NULL, '2'),
    ('The hāngī sounds delicious, I must try it!', '2023-08-05', 7, 1, '3'),
    -- Reply to the first comment
    ('Pavlova is my favorite dessert, can’t wait to have some!', '2023-08-06', 7, 2, '6'),
    -- Reply to the second comment

    -- Comments for article 2 of user3
    ('The wildlife in New Zealand is so unique!', '2023-08-07', 8, NULL, '1'),
    ('I would love to see a kiwi in the wild!', '2023-08-08', 8, 1, '4'),
    -- Reply to the first comment
    ('Hector’s dolphin sounds adorable, I hope to spot one!', '2023-08-09', 8, 2, '5'),
    -- Reply to the second comment

    -- Comments for article 3 of user3
    ('The history of New Zealand is fascinating!', '2023-08-10', 9, NULL, '2'),
    ('I didn’t know about the gold rush era, very interesting!', '2023-08-11', 9, 1, '3'),
    -- Reply to the first comment
    ('The Treaty of Waitangi is such an important part of history!', '2023-08-12', 9, 2, '6'),
    -- Reply to the second comment

    -- Comments for article 1 of user4
    ('The adventure activities in New Zealand are amazing!', '2023-08-31', 16, NULL, '2'),
    ('I would love to try bungee jumping in Queenstown!', '2023-09-01', 16, 1, '3'),
    -- Reply to the first comment
    ('The scenery while biking must be breathtaking!', '2023-09-02', 16, 2, '5'),
    -- Reply to the second comment

    -- Comments for article 2 of user4
    ('The Maori culture is so rich and fascinating!', '2023-09-03', 17, NULL, '1'),
    ('I would love to attend a cultural performance!', '2023-09-04', 17, 1, '6'),
    -- Reply to the first comment
    ('The traditional feasts sound delicious!', '2023-09-05', 17, 2, '7'),
    -- Reply to the second comment

    -- Comments for article 3 of user4
    ('The landscapes in New Zealand are stunning!', '2023-09-06', 18, NULL, '3'),
    ('I can’t wait to explore the national parks!', '2023-09-07', 18, 1, '4'),
    -- Reply to the first comment
    ('The diversity of ecosystems is incredible!', '2023-09-08', 18, 2, '5'),
    -- Reply to the second comment

    -- Comments for article 1 of user5
    ('The beaches in New Zealand are breathtaking!', '2023-09-09', 19, NULL, '2'),
    ('I would love to visit the Bay of Islands!', '2023-09-10', 19, 1, '3'),
    -- Reply to the first comment
    ('The surfing spots sound amazing!', '2023-09-11', 19, 2, '4'),
    -- Reply to the second comment

    -- Comments for article 2 of user5
    ('The hiking trails are a great way to explore nature!', '2023-09-12', 20, NULL, '1'),
    ('I can’t wait to hike the Routeburn Track!', '2023-09-13', 20, 1, '6'),
    -- Reply to the first comment
    ('The views from the trails must be stunning!', '2023-09-14', 20, 2, '7'),
    -- Reply to the second comment

    -- Comments for article 3 of user5
    ('The wildlife encounters in New Zealand are unforgettable!', '2023-09-15', 21, NULL, '3'),
    ('I hope to see the rare species during my visit!', '2023-09-16', 21, 1, '4'),
    -- Reply to the first comment
    ('The conservation efforts are inspiring!', '2023-09-17', 21, 2, '5'),
    -- Reply to the second comment

    -- Comments for article 1 of user6
    ('The cultural experiences in New Zealand are unique!', '2023-09-18', 22, NULL, '2'),
    ('I would love to learn about the Maori traditions!', '2023-09-19', 22, 1, '3'),
    -- Reply to the first comment
    ('The storytelling sessions sound fascinating!', '2023-09-20', 22, 2, '4'),
    -- Reply to the second comment

    -- Comments for article 2 of user6
    ('The adventure sports in New Zealand are thrilling!', '2023-09-21', 23, NULL, '1'),
    ('I can’t wait to try skydiving in Queenstown!', '2023-09-22', 23, 1, '5'),
    -- Reply to the first comment
    ('The bungee jumping experience sounds exhilarating!', '2023-09-23', 23, 2, '6'),
    -- Reply to the second comment

    -- Comments for article 3 of user6
    ('The natural beauty of New Zealand is breathtaking!', '2023-09-24', 24, NULL, '3'),
    ('I can’t wait to explore the national parks!', '2023-09-25', 24, 1, '4'),
    -- Reply to the first comment
    ('The diverse landscapes are a photographer’s dream!', '2023-09-26', 24, 2, '5'),
    -- Reply to the second comment

    -- Comments for article 1 of user7
    ('The history of New Zealand is so rich!', '2023-09-27', 25, NULL, '2'),
    ('I would love to learn more about the Treaty of Waitangi!', '2023-09-28', 25, 1, '3'),
    -- Reply to the first comment
    ('The gold rush era sounds fascinating!', '2023-09-29', 25, 2, '4'),
    -- Reply to the second comment

    -- Comments for article 2 of user7
    ('The culinary scene in New Zealand is diverse!', '2023-09-30', 26, NULL, '1'),
    ('I can’t wait to try the local seafood!', '2023-10-01', 26, 1, '5'),
    -- Reply to the first comment
    ('The farm-to-table dining experience sounds amazing!', '2023-10-02', 26, 2, '6'),
    -- Reply to the second comment

    -- Comments for article 3 of user7
    ('The adventure activities are a must-try!', '2023-10-03', 27, NULL, '3'),
    ('I can’t wait to go kayaking in Abel Tasman!', '2023-10-04', 27, 1, '4'),
    -- Reply to the first comment
    ('The hiking trails sound incredible!', '2023-10-05', 27, 2, '5'),
    -- Reply to the second comment

    -- Comments for article 1 of user8
    ('The landscapes in New Zealand are stunning!', '2023-10-06', 28, NULL, '2'),
    ('I would love to visit the Southern Alps!', '2023-10-07', 28, 1, '3'),
    -- Reply to the first comment
    ('The lakes look so serene and beautiful!', '2023-10-08', 28, 2, '4'),
    -- Reply to the second comment

    -- Comments for article 2 of user8
    ('The cultural experiences are so enriching!', '2023-10-09', 29, NULL, '1'),
    ('I can’t wait to learn about the Maori heritage!', '2023-10-10', 29, 1, '5'),
    -- Reply to the first comment
    ('The traditional feasts sound delicious!', '2023-10-11', 29, 2, '6'),
    -- Reply to the second comment

    -- Comments for article 3 of user8
    ('The wildlife encounters are unforgettable!', '2023-10-12', 30, NULL, '3'),
    ('I hope to see the rare species during my visit!', '2023-10-13', 30, 1, '4'),
    -- Reply to the first comment
    ('The conservation efforts are inspiring!', '2023-10-14', 30, 2, '5'),
    -- Reply to the second comment

    -- Comments for article 1 of admin1
    ('Wellington sounds like a vibrant city to explore!', '2023-08-13', 10, NULL, '5'),
    ('I can’t wait to visit Te Papa museum!', '2023-08-14', 10, 1, '6'),
    -- Reply to the first comment
    ('The coffee culture in Wellington is intriguing!', '2023-08-15', 10, 2, '7'),
    -- Reply to the second comment

    -- Comments for article 2 of admin1
    ('The Coromandel Peninsula looks stunning!', '2023-08-16', 11, NULL, '1'),
    ('I would love to dig my own hot pool at Hot Water Beach!', '2023-08-17', 11, 1, '2'),
    -- Reply to the first comment
    ('Cathedral Cove is a must-visit for me!', '2023-08-18', 11, 2, '3'),
    -- Reply to the second comment

    -- Comments for article 3 of admin1
    ('The flora and fauna of New Zealand are so diverse!', '2023-08-19', 12, NULL, '4'),
    ('I can’t believe how many unique species there are!', '2023-08-20', 12, 1, '5'),
    -- Reply to the first comment
    ('The conservation efforts are commendable!', '2023-08-21', 12, 2, '6'),
    -- Reply to the second comment

    -- Comments for article 1 of admin2
    ('Fiordland National Park looks breathtaking!', '2023-08-22', 13, NULL, '2'),
    ('I can’t wait to see the waterfalls in Milford Sound!', '2023-08-23', 13, 1, '3'),
    -- Reply to the first comment
    ('Doubtful Sound sounds like a peaceful escape!', '2023-08-24', 13, 2, '4'),
    -- Reply to the second comment

    -- Comments for article 2 of admin2
    ('The Waitomo Caves sound magical!', '2023-08-25', 14, NULL, '1'),
    ('I would love to see the glowworms in person!', '2023-08-26', 14, 1, '5'),
    -- Reply to the first comment
    ('The black water rafting sounds thrilling!', '2023-08-27', 14, 2, '6'),
    -- Reply to the second comment

    -- Comments for article 3 of admin2
    ('The Great Walks are a fantastic way to explore New Zealand!', '2023-08-28', 15, NULL, '3'),
    ('I can’t wait to hike the Milford Track!', '2023-08-29', 15, 1, '4'),
    -- Reply to the first comment
    ('The Abel Tasman Coast Track looks beautiful!', '2023-08-30', 15, 2, '5');
-- Reply to the second comment

-- Follow relationships
INSERT INTO follows
    (follower_id, followed_id)
VALUES
    ('1', '2'),
    ('1', '3'),
    ('1', '9'),
    ('2', '1'),
    ('2', '4'),
    ('3', '1'),
    ('3', '5'),
    ('4', '2'),
    ('4', '6'),
    ('5', '3'),
    ('5', '10'),
    ('6', '1'),
    ('6', '7'),
    ('7', '2'),
    ('7', '8'),
    ('8', '1'),
    ('8', '3'),
    ('9', '4'),
    ('9', '5'),
    ('10', '6'),
    ('10', '7');

-- Likes relationships
INSERT INTO likes
    (userid, article_id)
VALUES
    ('1', 1),
    -- Article 1 has 5 likes
    ('2', 1),
    ('3', 1),
    ('4', 1),
    ('5', 1),

    ('1', 2),
    -- Article 2 has 8 likes
    ('2', 2),
    ('3', 2),
    ('4', 2),
    ('5', 2),
    ('6', 2),
    ('7', 2),
    ('8', 2),

    ('1', 3),
    -- Article 3 has 3 likes
    ('2', 3),
    ('3', 3),

    ('1', 4),
    -- Article 4 has 2 likes
    ('2', 4),

    ('3', 5),
    -- Article 5 has 1 like
    ('4', 5),

    ('1', 6),
    -- Article 6 has 5 likes
    ('2', 6),
    ('3', 6),
    ('4', 6),
    ('5', 6),

    ('1', 7),
    -- Article 7 has 4 likes
    ('2', 7),
    ('3', 7),
    ('4', 7),

    ('1', 8),
    -- Article 8 has 2 likes
    ('2', 8),

    ('1', 9),
    -- Article 9 has 3 likes
    ('2', 9),
    ('3', 9),

    ('1', 10),
    -- Article 10 has 1 like
    ('2', 10),

    ('1', 11),
    -- Article 11 has 2 likes
    ('2', 11),

    ('1', 12),
    -- Article 12 has 3 likes
    ('2', 12),
    ('3', 12),

    ('1', 13),
    -- Article 13 has 3 likes
    ('2', 13),
    ('3', 13),

    ('1', 14),
    -- Article 14 has 4 likes
    ('2', 14),
    ('3', 14),
    ('4', 14),

    ('1', 15),
    -- Article 15 has 2 likes
    ('2', 15),

    ('1', 16),
    -- Article 16 has 1 like
    ('2', 16),

    ('1', 17),
    -- Article 17 has 2 likes
    ('2', 17),

    ('1', 18),
    -- Article 18 has 3 likes
    ('2', 18),
    ('3', 18),

    ('1', 19),
    -- Article 19 has 2 likes
    ('2', 19),

    ('1', 20),
    -- Article 20 has 3 likes
    ('2', 20),
    ('3', 20),

    ('1', 21),
    -- Article 21 has 2 likes
    ('2', 21),

    ('1', 22),
    -- Article 22 has 1 like
    ('2', 22),

    ('1', 23),
    -- Article 23 has 2 likes
    ('2', 23),

    ('1', 24),
    -- Article 24 has 3 likes
    ('2', 24),
    ('3', 24),

    ('1', 25),
    -- Article 25 has 1 like
    ('2', 25),

    ('1', 26),
    -- Article 26 has 2 likes
    ('2', 26),

    ('1', 27),
    -- Article 27 has 2 likes
    ('2', 27),

    ('1', 28),
    -- Article 28 has 1 like
    ('2', 28),

    ('1', 29),
    -- Article 29 has 1 like
    ('2', 29),

    -- Article 30 has 1 like
    ('1', 30);

-- Notify
INSERT INTO notify
    (article_id, userid, is_read)
VALUES
    (4, '1', FALSE),
    -- user1 is notified about article 1 by user2
    (5, '1', FALSE),
    -- user1 is notified about article 2 by user2
    (6, '1', FALSE),
    -- user1 is notified about article 3 by user2
    (7, '1', FALSE),
    -- user1 is notified about article 1 by user3
    (8, '1', FALSE),
    -- user1 is notified about article 2 by user3
    (9, '1', FALSE),
    -- user1 is notified about article 3 by user3
    (25, '1', FALSE),
    -- user1 is notified about article 1 by admin1
    (26, '1', FALSE),
    -- user1 is notified about article 2 by admin1
    (27, '1', FALSE),
    -- user1 is notified about article 3 by admin1

    (1, '2', FALSE),
    -- user2 is notified about article 1 by user1
    (2, '2', FALSE),
    -- user2 is notified about article 2 by user1
    (3, '2', FALSE),
    -- user2 is notified about article 3 by user1
    (10, '2', FALSE),
    -- user2 is notified about article 1 by user4
    (11, '2', FALSE),
    -- user2 is notified about article 2 by user4
    (12, '2', FALSE),
    -- user2 is notified about article 3 by user4

    (1, '3', FALSE),
    -- user3 is notified about article 1 by user1
    (2, '3', FALSE),
    -- user3 is notified about article 2 by user1
    (3, '3', FALSE),
    -- user3 is notified about article 3 by user1
    (13, '3', FALSE),
    -- user3 is notified about article 1 by user5
    (14, '3', FALSE),
    -- user3 is notified about article 2 by user5
    (15, '3', FALSE),
    -- user3 is notified about article 3 by user5

    (4, '4', FALSE),
    -- user4 is notified about article 1 by user2
    (5, '4', FALSE),
    -- user4 is notified about article 2 by user2
    (6, '4', FALSE),
    -- user4 is notified about article 3 by user2
    (16, '4', FALSE),
    -- user4 is notified about article 1 by user6
    (17, '4', FALSE),
    -- user4 is notified about article 2 by user6
    (18, '4', FALSE),
    -- user4 is notified about article 3 by user6

    (7, '5', FALSE),
    -- user5 is notified about article 1 by user3
    (8, '5', FALSE),
    -- user5 is notified about article 2 by user3
    (9, '5', FALSE),
    -- user5 is notified about article 3 by user3
    (28, '5', FALSE),
    -- user5 is notified about article 1 by admin2
    (29, '5', FALSE),
    -- user5 is notified about article 2 by admin2
    (30, '5', FALSE),
    -- user5 is notified about article 3 by admin2

    (1, '6', FALSE),
    -- user6 is notified about article 1 by user1
    (2, '6', FALSE),
    -- user6 is notified about article 2 by user1
    (3, '6', FALSE),
    -- user6 is notified about article 3 by user1
    (19, '6', FALSE),
    -- user6 is notified about article 1 by user7
    (20, '6', FALSE),
    -- user6 is notified about article 2 by user7
    (21, '6', FALSE),
    -- user6 is notified about article 3 by user7

    (4, '7', FALSE),
    -- user7 is notified about article 1 by user2
    (5, '7', FALSE),
    -- user7 is notified about article 2 by user2
    (6, '7', FALSE),
    -- user7 is notified about article 3 by user2
    (22, '7', FALSE),
    -- user7 is notified about article 1 by user8
    (23, '7', FALSE),
    -- user7 is notified about article 2 by user8
    (24, '7', FALSE),
    -- user7 is notified about article 3 by user8

    (1, '8', FALSE),
    -- user8 is notified about article 1 by user1
    (2, '8', FALSE),
    -- user8 is notified about article 2 by user1
    (3, '8', FALSE),
    -- user8 is notified about article 3 by user1
    (7, '8', FALSE),
    -- user8 is notified about article 1 by user3
    (8, '8', FALSE),
    -- user8 is notified about article 2 by user3
    (9, '8', FALSE),
    -- user8 is notified about article 3 by user3

    (10, '9', FALSE),
    -- admin1 is notified about article 1 by user4
    (11, '9', FALSE),
    -- admin1 is notified about article 2 by user4
    (12, '9', FALSE),
    -- admin1 is notified about article 3 by user4
    (13, '9', FALSE),
    -- admin1 is notified about article 1 by user5
    (14, '9', FALSE),
    -- admin1 is notified about article 2 by user5
    (15, '9', FALSE),
    -- admin1 is notified about article 3 by user5

    (16, '10', FALSE),
    -- admin2 is notified about article 1 by user6
    (17, '10', FALSE),
    -- admin2 is notified about article 2 by user6
    (18, '10', FALSE),
    -- admin2 is notified about article 3 by user6
    (19, '10', FALSE),
    -- admin2 is notified about article 1 by user7
    (20, '10', FALSE),
    -- admin2 is notified about article 2 by user7
    (21, '10', FALSE); -- admin2 is notified about article 3 by user7