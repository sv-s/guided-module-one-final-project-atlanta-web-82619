require 'pry'

class CommandLineInterface
    require "tty-prompt"

    def welcome_message
        puts ""
        puts "Welcome to My Community!"
        puts "An app that connects organizations to volunteers..."
        puts ""
        puts ""
        puts "Are you a new or returning user?"
    end

    def user_prompt
        @prompt = TTY::Prompt.new

        @prompt.select("") do |menu|
            menu.choice 'New User', -> { new_user }
            menu.choice 'Returning Volunteer', -> { volunteer_log_in }
            menu.choice 'Returning Organization', -> { organization_log_in }
            menu.choice 'Exit', -> { exit }
          end
    end

    def new_user
        @prompt.select("Please select an account option below:") do |menu|
            menu.choice "I'm a Volunteer", -> { new_volunteer }
            menu.choice "I'm an Organization", -> { new_organization }
            menu.choice 'Go back', -> { user_prompt }
        end
    end

    def new_volunteer
        new_user = @prompt.collect do
            key(:first_name).ask('First Name:', required: true)
            key(:last_name).ask('Last Name:', required: true)
            puts ""
            key(:username).ask('Username:', required: true)
            key(:password).ask('Password:', required: true)
        end

        user = Volunteer.create(first_name: user[:first_name], last_name: user[:last_name], username: user[:username], password: user[:password])

        puts "Welcome #{new_user[:first_name]}! Thanks for joining."
        puts ""
        puts "***************"
        puts ""
        puts ""
        volunteer_main_menu(user)
    end

    def new_organization
        new_user = @prompt.collect do
            key(:name).ask('Organization Name:', required: true)
            key(:city).ask('City:', required: true)
            key(:state).ask('State:', required: true)
            puts ""
            key(:username).ask('Username:', required: true)
            key(:password).ask('Password:', required: true)
        end

        user = Organization.create(name: user[:name], username: user[:username], password: user[:password], state: user[:state], city: user[:city])

        puts "Welcome #{new_user[:name]}! Thanks for joining."
        puts ""
        puts "***************"
        puts ""
        puts ""
        organization_main_menu(user)
    end

    def volunteer_log_in
        first_name = "PLACEHOLDER"

        user = @prompt.collect do
            first_name = "PLACEHOLDER"

            key(:username).ask('Enter your Username:', required: true)
            key(:password).ask('Enter your Password:', required: true)
            puts ""
            puts "Welcome back #{first_name}! Great to see you again."
            puts ""
            puts "***************"
            puts ""
            puts ""
        end
        volunteer_main_menu(user)
    end

    def organization_log_in
        name = "PLACEHOLDER"

        user = @prompt.collect do
            first_name = "PLACEHOLDER"

            key(:username).ask('Enter your Username:', required: true)
            key(:password).ask('Enter your Password:', required: true)
            puts ""
            puts "Welcome back #{name}! Great to see you again."
            puts ""
            puts "***************"
            puts ""
            puts ""
        end
        organization_main_menu(user)
    end

    def volunteer_main_menu(user)
        puts "*** MAIN MENU ***"

        user = @prompt.select("") do |menu|
            menu.choice "I'm here to Volunteer", -> { go_to_volunteer(user) }
            menu.choice 'View My Reviews', -> { my_reviews_volunteer(user) }
            menu.choice 'View Previous Volunteer Records', -> { volunteer_records_for_volunteer(user) }
            menu.choice 'Update Profile', -> { volunteer_update_profile(user) }
            menu.choice 'Log Out', -> { log_out }
        end
    end

    def organization_main_menu(user)
        puts "*** MAIN MENU ***"

        user = @prompt.select("") do |menu|
            menu.choice 'View Previous Volunteer Records', -> { volunteer_records_for_organization(user) }
            menu.choice 'View My Reviews', -> { my_reviews_organization(user) }
            menu.choice 'Update Profile', -> { organization_update_profile(user) }
            menu.choice 'Log Out', -> { log_out }
        end
    end

    def all_cities
        Organization.all.map { |o| o.city }.uniq
    end

    def all_states
        Organization.all.map { |o| o.state }.uniq
    end

    def go_to_volunteer(user)
        puts "*** ORGANIZATIONS ***"
        puts ""
        puts "Please enter a city and state below to find organizations near you!"

        input = @prompt.collect do
            key(:city).ask('City:', required: true)
            key(:state).ask('State:', required: true)
        end

        APICommunicator.location_search_retrieve(input[:city], input[:state], page_limit = 1)

        orgs = Organization.all.select { |o| o.city.downcase == input[:city].downcase && o.state.downcase == input[:state].downcase }
        org_names = orgs.map { |o| o.name }
        puts ""
        puts ""

        selection = @prompt.select("Select an organization", org_names)
        select_organization(selection, user)
        puts ""
        puts ""
        puts "***************"
        puts ""
    end

    def select_organization(selection, user)
        my_org = Organization.all.select { |o| o.name.downcase == selection.downcase }

        puts "*** Welcome to #{selection}! ***"
        puts ""
        @prompt.select("") do |m| 
            m.choice "Volunteer Now", -> { clock_in_and_out(selection, user) }
            m.choice "Main Menu", -> { volunteer_main_menu(user) }
        end
        puts ""
    end

    def clock_in_and_out(selection, user)

        my_org = Organization.all.select { |o| o.name.downcase == selection.downcase }
        org = my_org.map { |o| o.id }

        status = @prompt.select("") do |menu|
            menu.choice 'Clock In', -> { clock_in(user, org) }
            menu.choice 'Clock Out', -> { clock_out(user, org) }
            menu.choice 'Main Menu', -> { volunteer_main_menu(user) }
        end
    end

    def clock_in(user, org)

        Log.create(volunteer_id: user, organization_id: org, clock_in: Time.now.strftime("%H:%M"))

        puts ""
        puts "*"
        puts "clocked in"
        @prompt.select("") { |m| m.choice "Done", -> { volunteer_main_menu(user) }}
    end

    def clock_out(user, org)
        
        recent = Log.all.select { |l| l.volunteer_id == user }.last
        recent.update(clock_out: Time.now.strftime("%H:%M"))

        

        puts ""
        puts "*"
        puts "clocked out"
        puts "You Worked for #{time}!"
        @prompt.select("") { |m| m.choice "Done", -> { volunteer_main_menu(user) }}
    end

    def my_reviews_volunteer(user)
        puts "*** MY REVIEWS ***"
        puts ""

        ### outputs the reviews a volunteer has left

        @prompt.select("") { |m| m.choice "Exit", -> { volunteer_main_menu(user) }}
    end

    def my_reviews_organization(user)
        puts "*** MY REVIEWS ***"
        puts ""

        ### outputs the reviews an organization has recieved

        @prompt.select("") { |m| m.choice "Exit", -> { organization_main_menu(user) }}
    end

    def volunteer_records_for_volunteer(user)
        puts "*** VOLUNTEER RECORDS ***"
        puts ""

        ### outputs all records for volunteers

        @prompt.select("") { |m| m.choice "Exit", -> { volunteer_main_menu(user) }}
    end

    def volunteer_records_for_organization(user)
        puts "*** VOLUNTEER RECORDS ***"
        puts ""

        ### outputs all volunteers that have volunteered at organization

        @prompt.select("") { |m| m.choice "Exit", -> { organization_main_menu(user) }}
    end

    def volunteer_update_profile(user)
        puts "*** UPDATE PROFILE ***"

        @prompt.select("") do |menu| 
            menu.choice "Update First Name", -> { update_first_name(user) }
            menu.choice "Update Last Name", -> { update_last_name(user) } 
            menu.choice "Update Password", -> { update_password(user) }
            menu.choice "Delete My Account", -> { account_delete(user) }
            menu.choice "Go back", -> { volunteer_main_menu(user) }
        end
    end

    def organization_update_profile(user)
        puts "*** UPDATE PROFILE ***"

        @prompt.select("") do |menu| 
            menu.choice "Update Organization Name", -> { update_org_name(user) }
            menu.choice "Update City", -> { update_city(user) }
            menu.choice "Update State", -> { update_state(user) }
            menu.choice "Update Password", -> { update_password(user) }
            menu.choice "Delete My Account", -> { account_delete(user) }
            menu.choice "Go Back", -> { organization_main_menu(user) }
        end
    end

    def update_first_name(user)
        ### UPDATE FIRST NAME
    end

    def update_last_name(user)
        ### UPDATE LAST NAME
    end

    def update_org_name(user)
        ### UPDATE ORGANIZATION NAME
    end

    def update_city(user)
        ### UPDATE CITY
    end

    def update_state(user)
        ### UPDATE STATE
    end

    def update_password(user)
        ### UPDATE PASSWORD
    end

    def account_delete(user)
        ### DELETE ACCOUNT INSTANCE
    end

    def log_out
        puts ""
        puts "Thanks for using My Community!"
        puts "Hope to see you again soon."
        user_prompt
    end
end