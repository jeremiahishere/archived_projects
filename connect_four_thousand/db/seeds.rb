admin_role = Role.find_or_create_by_name("admin")
basic_role = Role.find_or_create_by_name("basic_user")

u = User.find_or_create_by_email("admin@connectfourthousand.com", :password => "password", :password_confirmation => "password")
u.roles = [admin_role]
u.save

u = User.find_or_create_by_email("basicuser@connectfourthousand.com", :password => "password", :password_confirmation => "password")
u.roles = [basic_role]
u.save
