# organization1 = Organization.create(name: 'ProjectDowntown',state: 'Florida',city: 'Jacksonville',username: 'pd_jax',password:'jax')
# organization2 = Organization.create(name: 'Humane Society',state: 'Georgia',city: 'Atlanta',username: 'humane_atl',password: 'atl')
# organization3 = Organization.create(name: 'ProjectDowntown',state: 'Florida',city:'Tampa',username:'pd_tampa',password: 'tampa')
# organization4 = Organization.create(name: 'ProjectDowntown',state: 'Florida',city:'Miami',username:'pd_mia',password:'mia')
# organization5 = Organization.create(name:' ProjectDowntown',state: 'Florida',city:'Tallahassee',username:'pd_tally',password:'tally')


v1 = Volunteer.create(first_name: 'Raza',last_name: 'Shareef',username: 'raza23',password: 'shar23')
v2 = Volunteer.create(first_name: 'Alex',last_name: 'Pugia',username: 'apug',password: 'alex1')
v3 = Volunteer.create(first_name: 'Andrew',last_name: 'Kim',username: 'akim',password: 'andrew1')

api = APICommunicator.new
api.default_results['organizations'].each do |org|
    Organization.create(name: org['name'], state: org['state'], city: org['city'], username: org['ein'], password: 'password')
end