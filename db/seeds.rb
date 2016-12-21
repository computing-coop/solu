# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Partner.create(name: 'Finnish Society of Bioart', website: 'http://bioartsociety.fi', country: 'FI')
Partner.create(name: 'ITU Copenhagen', website: 'http://www.itu.dk', country: 'DK')
Partner.create(name: 'Kunsthall Grenland', website: 'http://kunsthallgrenland.no/', country: 'NO')
Partner.create(name: 'å+k', website: 'å+k', country: 'SE')
Partner.create(name: 'Forum Box', website: 'http://forumbox.fi', country: 'FI')


a = Activity.create(
name: 'Network meeting I', activity_type: 'kick-off meeting', start_at: '2014-09-15', end_at: '2014-09-18', responsible_organisations: [ Partner.find_by(name: 'Kunsthall Grenland') ]
)

Activity.create(
name: 'Production of artistic research project', activity_type: 'art&science research',
start_at: '2015-01-01', end_at: '2015-12-31', 
responsible_organisations: [ Partner.find_by(name: 'ITU Copenhagen') ]
)

Activity.create(
name: 'Public Engagement Events', activity_type: 'citizen art&science', 
start_at: '2015-01-01', end_at: '2015-12-31',
responsible_organisations: [ Partner.find_by(name: 'å+k') ]
)

Activity.create(
name: 'Call for additional artworks', activity_type: 'production and curating of the exhibition',
start_at: '2015-01-01', end_at: '2015-12-31', 
responsible_organisations: [ Partner.all ]
)

Activity.create(
name: 'Network meeting II', activity_type: 'midterm meeting', 
start_at: '2015-03-01', end_at: '2015-03-04', 
responsible_organisations: [ Partner.find_by(name: 'ITU Copenhagen') ]
)

Activity.create(
name: 'HYBRID MATTERS digital communication and dissemination platform',
activity_type: 'launch', start_at: '2015-03-15', 
responsible_organisations: [  Partner.find_by(name: 'Finnish Society of Bioart') ]
)

Activity.create(
name: 'Field_Notes', activity_type: 'HYBRID MATTERS field laboratory in Kilpisjärvi',
start_at: '2015-09-14', end_at: '2015-09-20', 
responsible_organisations: [  Partner.find_by(name: 'Finnish Society of Bioart') ]
)

Activity.create(
  name: 'HYBRID MATTERS exhibition I', activity_type: 'exhibition', 
  start_at: '2016-03-01', end_at: '2016-04-01', 
  responsible_organisations: [ Partner.find_by(name: 'Kunsthall Grenland') ]
)

Activity.create(
  name: 'HYBRID MATTERS exhibition II', activity_type: 'exhibition', 
  start_at: '2016-07-01', end_at: '2016-08-01'
)

Activity.create(
  name: 'HYBRID MATTERS exhibition III', activity_type: 'exhibition', 
  start_at: '2016-10-15', end_at: '2016-11-30', 
  responsible_organisations: [ Partner.find_by(name: 'Forum Box') ]
)

Activity.create(
  name: 'HYBRID MATTERS symposium', activity_type: 'symposium',
  start_at: '2016-11-01', end_at: '2016-11-03',
  responsible_organisations: [  Partner.find_by(name: 'Finnish Society of Bioart') ]
)
  
Activity.create(
  name: 'Network meeting III', activity_type: 'final meeting',
  start_at: '2016-12-01', end_at: '2016-12-04',
  responsible_organisations: [  Partner.find_by(name: 'Finnish Society of Bioart'),  Partner.find_by(name: 'Forum Box')]
)

Node.create(
  name: 'bioart', description: 'Finnish Society of Bioart', subdomains: 'bioartsociety'
)

Node.create(
  name: 'hybrid_matters', description: 'HYBRID_MATTERs', subdomains: 'hybridmatters'
)