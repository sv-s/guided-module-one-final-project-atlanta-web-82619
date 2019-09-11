require_relative '../config/environment'
new_cli = CommandLineInterface.new

new_cli.welcome_message
new_cli.user_prompt
new_cli.main_menu
