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
        prompt = TTY::Prompt.new

        prompt.select("") do |menu|
            menu.choice 'New User', -> { new_user }
            menu.choice 'Returning Volunteer', -> { volunteer_log_in }
            menu.choice 'Returning Organization', -> { organization_log_in }
            menu.choice 'Exit', -> { exit }
          end
    end

    def new_user
        prompt = TTY::Prompt.new

        prompt.select("Please select an account option below:") do |menu|
            menu.choice "I'm a Volunteer", -> { new_volunteer }
            menu.choice "I'm an Organization", -> { new_organization }
            menu.choice 'Go back', -> { user_prompt }
        end
    end

    def new_volunteer
        prompt = TTY::Prompt.new

        user = prompt.collect do
            key(:first_name).ask('First Name:', required: true)
            key(:last_name).ask('Last Name:', required: true)
            puts ""
            key(:username).ask('Username:', required: true)
            key(:password).ask('Password:', required: true)
        end

        Volunteer.create(first_name: user[:first_name], last_name: user[:last_name], username: user[:username], password: user[:password])

        puts "Welcome #{user[:first_name]}! Thanks for joining."
        puts ""
        puts "***************"
        puts ""
        puts ""
        volunteer_main_menu
    end

    def new_organization
        prompt = TTY::Prompt.new

        user = prompt.collect do
            key(:name).ask('Organization Name:', required: true)
            key(:city).ask('City:', required: true)
            key(:state).ask('State:', required: true)
            puts ""
            key(:username).ask('Username:', required: true)
            key(:password).ask('Password:', required: true)
        end

        Organization.create(name: user[:name], username: user[:username], password: user[:password], state: user[:state], city: user[:city])

        puts "Welcome #{user[:name]}! Thanks for joining."
        puts ""
        puts "***************"
        puts ""
        puts ""
        organization_main_menu
    end

    def volunteer_log_in
        prompt = TTY::Prompt.new
        first_name = "PLACEHOLDER"

        user = prompt.collect do
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
        volunteer_main_menu
    end

    def organization_log_in
        prompt = TTY::Prompt.new
        name = "PLACEHOLDER"

        user = prompt.collect do
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
        organization_main_menu
    end

    def volunteer_main_menu
        prompt = TTY::Prompt.new

        puts "*** MAIN MENU ***"

        user = prompt.select("") do |menu|
            menu.choice "I'm here to Volunteer", -> { go_to_volunteer }
            menu.choice 'View My Reviews', -> { my_reviews }
            menu.choice 'View Previous Volunteer Records', -> { volunteer_records }
            menu.choice 'Update Profile', -> { volunteer_update_profile }
            menu.choice 'Log Out', -> { log_out }
        end
    end

    def organization_main_menu
        prompt = TTY::Prompt.new

        puts "*** MAIN MENU ***"

        user = prompt.select("") do |menu|
            menu.choice 'View Previous Volunteer Records', -> { volunteer_records }
            menu.choice 'View My Reviews', -> { my_reviews }
            menu.choice 'Update Profile', -> { organization_update_profile }
            menu.choice 'Log Out', -> { log_out }
        end
    end

    def go_to_volunteer #for volunteers only
        prompt = TTY::Prompt.new

        puts "*** ORGANIZATIONS ***"
        puts ""
        puts "Please enter a city and state below to find organizations near you!"
        input = prompt.collect do
            key(:city).ask('City:', required: true)
            key(:state).ask('State:', required: true)
        end
        
       puts Organization.all.select { |o| o.city.downcase == input[:city].downcase && o.state.downcase == input[:state].downcase }
        ### takes a (city, state) and outputs set number of organizations in that city, state

        prompt.select("") { |m| m.choice "Exit", -> { volunteer_main_menu }}
    end

    def my_reviews
        prompt = TTY::Prompt.new

        puts "*** MY REVIEWS ***"
        puts ""

        ### outputs the reviews a volunteer has left OR the reviews an organization has recieved

        prompt.select("") { |m| m.choice "Exit", -> { main_menu }}
    end

    def volunteer_records
        prompt = TTY::Prompt.new

        puts "*** VOLUNTEER RECORDS ***"
        puts ""

        ### outputs all records for volunteers OR all volunteers that have volunteered at organization

        prompt.select("") { |m| m.choice "Exit", -> { main_menu }}
    end

    def volunteer_update_profile
        prompt = TTY::Prompt.new
        puts "*** UPDATE PROFILE ***"

        prompt.select("") do |menu| 
            menu.choice "Update First Name", -> { } #update first name
            menu.choice "Update Last Name", -> { } #update last name 
            menu.choice "Update Password", -> { } #update password
            menu.choice "Delete My Account", -> { account_delete }
            menu.choice "Go back", -> { volunteer_main_menu }
        end
    end

    def organization_update_profile
        prompt = TTY::Prompt.new
        puts "*** UPDATE PROFILE ***"

        prompt.select("") do |menu| 
            menu.choice "Update Organization Name", -> { } #update name
            menu.choice "Update City", -> { } #update city
            menu.choice "Update State", -> { } #update state
            menu.choice "Update Password", -> { } #update password
            menu.choice "Delete My Account", -> { account_delete }
            menu.choice "Go Back", -> { organization_main_menu }
        end
    end

    def account_delete

    end

    def log_out
        puts ""
        puts "Thanks for using My Community!"
        puts "Hope to see you again soon."
        user_prompt
    end
end