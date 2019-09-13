
require 'pry'

class CommandLineInterface
    require "tty-prompt"
    def run
        @pastel = Pastel.new
        @prompt = TTY:Prompt.new
        @font = TTY::Font.new(:doom)

        welcome_message
    end

    def welcome_message
        @font1 = TTY::Font.new(:doom)
        puts ""
        x =  "Welcome to My Community!"
        puts @font1.write(x,letter_spacing:1)
        puts "An app that connects organizations to volunteers..."
        puts ""
        puts ""
        puts "Are you a new or returning user?"
        sleep 2
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
        @pastel = Pastel.new
        new_user = @prompt.collect do
            key(:first_name).ask('First Name:', required: true)
            key(:last_name).ask('Last Name:', required: true)
            puts ""
            key(:username).ask('Username:', required: true)
            key(:password).ask('Password:', required: true)
        end

        if Volunteer.where(username: new_user[:username]).exists? == true
            puts "username taken, try again."
            puts ""
            puts ""
            new_volunteer
        else
            user = Volunteer.create(first_name: new_user[:first_name], last_name: new_user[:last_name], username: new_user[:username], password: new_user[:password])
            puts "Welcome #{new_user[:first_name]}! Thanks for joining."
            puts ""
            puts @pastel.red("                          ")
            puts ""
            puts ""
            volunteer_main_menu(user)
        end
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

        if Organization.where(username: new_user[:username]).exists? == true
            puts "username taken, try again."
            puts ""
            puts ""
            new_organization
        else
            user = Organization.create(name: new_user[:name], username: new_user[:username], password: new_user[:password], state: new_user[:state], city: new_user[:city])
            puts "Welcome #{new_user[:name]}! Thanks for joining."
            puts ""
            puts @pastel.inverse.red('***************')
            puts ""
            puts ""
            organization_main_menu(user)
        end
    end

    def volunteer_log_in
        @pastel = Pastel.new
        returning_user = @prompt.collect do
            key(:username).ask('Enter your Username:', required: true)
            key(:password).ask('Enter your Password:', required: true)
        end

        if Volunteer.all.select { |v| v.username == returning_user[:username] } == []
            puts "Username not found, please sign up."
            @prompt.select("") do |m| 
                m.choice "Let's go!", -> { new_volunteer }
                m.choice "No thanks.", -> { user_prompt }
            end
        else
            user = Volunteer.all.select { |v| v.username == returning_user[:username] }
            user_first_name = user.map { |v| v.first_name }
            puts ""
            puts "Welcome back #{user_first_name[0]}! Great to see you again."
            puts @pastel.blue("***************")
            puts ""
            volunteer_main_menu(user)
        end
    end

    def organization_log_in
        new_user = @prompt.collect do
            key(:username).ask('Enter your Username:', required: true)
            key(:password).ask('Enter your Password:', required: true)
        end

        if Organization.all.select { |o| o.username == new_user[:username] } == []
            puts "Username not found, please sign up."
            @prompt.select("") do |m| 
                m.choice "Let's go!", -> { new_organization }
                m.choice "No thanks.", -> { user_prompt }
            end
        else
            user = Organization.all.select { |o| o.username == new_user[:username] }.first
            puts ""
            puts "Welcome back #{user.name}! Great to see you again."
            puts ""
            puts "***************"
            puts ""
            puts ""
            organization_main_menu(user)
        end
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
        if org_names == []
            puts 'No matches found try again'
            go_to_volunteer(user)
        else
        selection = @prompt.select("Select an organization", org_names)
        select_organization(selection, user)
        puts ""
        puts ""
        puts "***************"
        puts ""
    end
end

    def select_organization(selection, user)
        my_org = Organization.all.select { |o| o.name == selection }

        puts "*** Welcome to #{selection}! ***"
        puts ""
        @prompt.select("") do |m| 
            m.choice "Volunteer Now", -> { clock_in_and_out(selection, user) }
            m.choice "Main Menu", -> { volunteer_main_menu(user) }
        end
        puts ""
    end

    def clock_in_and_out(selection, user)

        my_org = Organization.all.select { |o| o.name == selection }
        org = my_org.map { |o| o.id }

        status = @prompt.select("") do |menu|
            menu.choice 'Clock In', -> { user_clock_in(user, org) }
            menu.choice 'Clock Out', -> { user_clock_out(user, org) }
            menu.choice 'Main Menu', -> { volunteer_main_menu(user) }
        end
    end

    def user_clock_in(user, org)

        user_id = user[:id] 
        Log.create(volunteer_id: user_id[0], organization_id: org[0], clock_in: Time.now.strftime("%H:%M"))

        puts ""
        puts "*"
        puts "clocked in"
        @prompt.select("") { |m| m.choice "Done", -> { volunteer_main_menu(user) }}
    end

    def user_clock_out(user, org)
        
        user_id = user[:id]
        recent = Log.find_by(volunteer_id: user_id[0], organization_id: org[0])
        recent.update(clock_out: Time.now.strftime("%H:%M"))

        out = recent.clock_out.split(":")
        total_out = (out[0].to_i * 60) + out[1].to_i
        inn = recent.clock_in.split(":")
        total_inn = (inn[0].to_i * 60) + inn[1].to_i

        time = total_out - total_inn
        

        puts ""
        puts "*"
        puts "clocked out"
        puts "You Worked for #{time} minutes!"
        @prompt.select("") { |m| m.choice "Done", -> { volunteer_main_menu(user) }}
    end

    def my_reviews_volunteer(user)
        puts "*** MY REVIEWS ***"
        puts ""

        my_reviews = Review.all.select { |r| r.volunteer_id == user.id }

        @prompt.select("") { |m| m.choice "Exit", -> { volunteer_main_menu(user) }}
    end

    def my_reviews_organization(user)
        puts "*** MY REVIEWS ***"
        puts ""

        my_reviews = Review.all.select { |r| r.organization_id == user.id }

        @prompt.select("") { |m| m.choice "Exit", -> { organization_main_menu(user) }}
    end

    def volunteer_records_for_volunteer(user)
        puts "*** VOLUNTEER RECORDS ***"
        puts ""

        user_id_set = user.map { |u| u.id }
        my_logs = Log.all.select { |l| l.volunteer_id == user_id_set[0] }

        @prompt.select("") { |m| m.choice "Exit", -> { volunteer_main_menu(user) }}
    end

    def volunteer_records_for_organization(user)
        puts "*** VOLUNTEER RECORDS ***"
        puts ""

        my_logs = Log.all.select { |l| l.organization_id == user.id }

        @prompt.select("") { |m| m.choice "Exit", -> { organization_main_menu(user) }}
    end

    def volunteer_update_profile(user)
        puts "*** UPDATE PROFILE ***"

        @prompt.select("") do |menu| 
            menu.choice "Update First Name", -> { update_first_name(user) }
            menu.choice "Update Last Name", -> { update_last_name(user) } 
            menu.choice "Update Password", -> { update_volunteer_password(user) }
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
            menu.choice "Update Password", -> { update_organization_password(user) }
            menu.choice "Delete My Account", -> { account_delete(user) }
            menu.choice "Go Back", -> { organization_main_menu(user) }
        end
    end

    def update_first_name(user)
        input = @prompt.collect do
            key(:name).ask('Enter New First Name:', required: true)
        end

        user_id = user.map { |u| u.id }
        person = Volunteer.find_by(id: user_id[0])
        person.update(first_name: input[:name])

        puts "SUCCESS..."
        puts ""
        puts "First Name changed to #{input[:name]}."
        
        @prompt.select("") { |m| m.choice "Done", -> { volunteer_main_menu(user) }}
    end

    def update_last_name(user)
        input = @prompt.collect do
            key(:name).ask('Enter New Last Name:', required: true)
        end

        user_id = user.map { |u| u.id }
        person = Volunteer.find_by(id: user_id[0])
        person.update(last_name: input[:name])

        puts "SUCCESS..."
        puts ""
        puts "Last Name changed to #{input[:name]}."
        
        @prompt.select("") { |m| m.choice "Done", -> { volunteer_main_menu(user) }}
    end

    def update_org_name(user)
        input = @prompt.collect do
            key(:name).ask('Enter New Organization Name:', required: true)
        end

        person = Organization.find_by(id: user.id)
        person.update(name: input[:name])

        puts "SUCCESS..."
        puts ""
        puts "Organization Name changed to #{input[:name]}."
        
        @prompt.select("") { |m| m.choice "Done", -> { organization_main_menu(user) }}
    end

    def update_city(user)
        input = @prompt.collect do
            key(:name).ask('Enter New City:', required: true)
        end

        person = Organization.find_by(id: user.id)
        person.update(city: input[:name])

        puts "SUCCESS..."
        puts ""
        puts "City changed to #{input[:name]}."
        
        @prompt.select("") { |m| m.choice "Done", -> { organization_main_menu(user) }}
    end

    def update_state(user)
        input = @prompt.collect do
            key(:name).ask('Enter New State:', required: true)
        end

        person = Organization.find_by(id: user.id)
        person.update(state: input[:name])

        puts "SUCCESS..."
        puts ""
        puts "State changed to #{input[:name]}."
        
        @prompt.select("") { |m| m.choice "Done", -> { organization_main_menu(user) }}
    end

    def update_volunteer_password(user)
        new_user = user.map { |u| u.username }
        input = @prompt.collect do
            key(:name).ask('Enter New Password:', required: true)
        end

        user_id = user.map { |u| u.id }
        person = Volunteer.find_by(id: user_id[0])
        person.update(password: input[:name])

        puts "SUCCESS..."
        puts ""
        puts "Password changed to #{input[:name]}."

        @prompt.select("") { |m| m.choice "Done", -> { volunteer_main_menu(user) }}
    end

    def update_organization_password(user)
        input = @prompt.collect do
            key(:name).ask('Enter New Password:', required: true)
        end

        person = Organization.find_by(id: user.id)
        person.update(password: input[:name])

        puts "SUCCESS..."
        puts ""
        puts "Password changed to #{input[:name]}."

        @prompt.select("") { |m| m.choice "Done", -> { organization_main_menu(user) }}
    end

    def account_delete(user)
        if Volunteer.find_by(username: user.username)
            input = @prompt.select("Are you sure you want to delete your account?") do |menu|
                menu.choice 'Yes.', -> { "We'll miss you!" }
                menu.choice 'Nevermind...', -> { volunteer_main_menu(user) }
            end

            user_id = user.map { |u| u.id }
            person = Volunteer.find_by(id: user_id[0])
            person.delete

            puts "SUCCESS..."
            puts ""
            puts ""

            @prompt.select("") { |m| m.choice "Goodbye!", -> { log_out }}

        elsif Organization.find_by(username: user.username)
            input = @prompt.select("Are you sure you want to delete your account?") do |menu|
                menu.choice 'Yes.'
                menu.choice 'Nevermind...', -> { organization_main_menu(user) }
            end

            person = Organization.find_by(id: user.id)
            person.delete

            puts "SUCCESS..."
            puts ""
            puts ""

            @prompt.select("") { |m| m.choice "Goodbye!", -> { log_out }}
        end
    end

    def log_out
        puts ""
        puts "Thanks for using My Community!"
        puts "Hope to see you again soon."
        user_prompt
    end
end