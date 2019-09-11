#ruby bin/run.rb
require 'pry'
class CLI
    def run
        @employee = nil
        @pastel = Pastel.new
        @prompt = TTY::Prompt.new
        @font = TTY::Font.new(:doom)
    
    title
    end

    def title
        title1 = "Welcome"
        puts @pastel.red.bold(@font.write(title1,letter_spacing:1))
        sleep 3

       main_menu 
    end

    def main_menu
        choices= ["Volunteer Login","Organization Login","Exit"]
        choice = (@prompt.enum_select("Choose You Option.",choices))       
        if choice == choices[0]
            volunteer_login 
        elsif choice == choices[1]
            manager_login
        else choice == choices[2]
            
            puts "Thank You"
            exit
        end
     end

     def volunteer_login
        choices=['Existing Volunteer?','New Volunteer?','Exit']
        choice = (@prompt.enum_select("Choose You Option.",choices))       
        if choice == choices[0]
            existing_vol 
        elsif choice == choices[1]
            new_vol
        else choice == choices[2]
            
            puts "Thank You"
            exit
        end
     end

     def existing_vol
        puts 'Please Enter Your Username'
        username = gets.chomp
        x = Volunteer.all.find_by(username: username)
        
        puts x


        

     end



end