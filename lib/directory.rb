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
            menu.choice 'Returning User', -> { log_in }
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

        puts "Welcome #{user[:first_name]}! Thanks for joining."
        puts ""
        puts "***************"
        puts ""
        puts ""
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

        puts "Welcome #{user[:name]}! Thanks for joining."
        puts ""
        puts "***************"
        puts ""
        puts ""
    end

    def log_in
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
        main_menu
    end

    def main_menu
        prompt = TTY::Prompt.new

        puts "*** MAIN MENU ***"

        user = prompt.select("") do |menu|
            menu.choice "I'm here to Volunteer", -> { go_to_volunteer }
            menu.choice 'View My Reviews', -> { my_reviews }
            menu.choice 'View Previous Volunteer Records', -> { prev_volunteer_records }
            menu.choice 'Update Profile', -> { update_profile }
            menu.choice 'Log Out', -> { log_out }
        end
    end

    def go_to_volunteer
        prompt = TTY::Prompt.new

        puts "*** ORGANIZATIONS ***"
        puts ""

        prompt.select("") { |m| m.choice "Exit", -> { main_menu }}
    end

    def my_reviews
        prompt = TTY::Prompt.new

        puts "*** MY REVIEWS ***"
        puts ""

        prompt.select("") { |m| m.choice "Exit", -> { main_menu }}
    end

    def prev_volunteer_records
        prompt = TTY::Prompt.new

        puts "*** MY PRIOR VOLUNTEER RECORDS ***"
        puts ""

        prompt.select("") { |m| m.choice "Exit", -> { main_menu }}
    end

    def update_profile
        prompt = TTY::Prompt.new
        puts "*** UPDATE PROFILE ***"

        ### CHANGE CODE BELOW TO ACCESS DATABASE

        if  user[:type ]== volunteer #user == volunteer
            prompt.select("") do |menu| 
                menu.choice "Update First Name", -> { } #update first name
                menu.choice "Update Last Name", -> { } #update last name 
                menu.choice "Update Password", -> { } #update password
                menu.choice "Go Back", -> { main_menu }
            end
        else #user == organization
            prompt.select("") do |menu| 
                menu.choice "Update Organization Name", -> { } #update name
                menu.choice "Update City", -> { } #update city
                menu.choice "Update State", -> { } #update state
                menu.choice "Update Password", -> { } #update password
                menu.choice "Go Back", -> { main_menu }
            end
        end
    end

    def log_out
        puts ""
        puts "Thanks for using My Community!"
        puts "Hope to see you again soon."
        user_prompt
    end

end