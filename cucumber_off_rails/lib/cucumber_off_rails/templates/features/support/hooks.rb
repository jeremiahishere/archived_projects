AfterStep('@debug') do |scenario|
  puts current_url
end

Before('@login') do |scenario|
  Given %{I am on the Login page}
  When %{I fill in "#{@@user[:email]}" for "Email"}
  And %{I fill in "#{@@user[:password]}" for "Password"}
  And %{I press "Login"}
  Then %{I should be on the Homepage}
  And %{I should see "Login successful!"}
end

After('@login') do |scenario|
  Given %{I am on the Logout page}
  Then %{I should see "Logout successful"}
end
