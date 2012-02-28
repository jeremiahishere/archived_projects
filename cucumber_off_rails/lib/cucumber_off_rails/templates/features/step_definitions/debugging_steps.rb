When(/^I debug$/) do
  debugger
end

When(/^I sleep for ([^"]*) second[s]?$/) do |time|
  sleep(time.to_i)
end

Then(/^show me the page$/) do
  save_and_open_page
end
