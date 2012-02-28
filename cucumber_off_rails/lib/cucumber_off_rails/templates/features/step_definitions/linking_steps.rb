require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given(/^(?:|I )am on (.+)$/) do |page_name|
  visit path_to(page_name)
end

When( /^(?:|I )go to (.+)$/) do |page_name|
  visit path_to(page_name)
end

When(/^(?:|I )press "([^"]*)"(?: within "([^"]*)")?$/) do |button, selector|
  with_scope(selector) do
    click_button(button)
  end
end

When(/^(?:|I )follow "([^"]*)"(?: within "([^"]*)")?$/) do |link, selector|
  with_scope(selector) do
    click_link(link)
  end
end

Then(/^(?:|I )should be on (.+)$/) do |page_name|
  # given method
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == path_to(page_name)
  else
    assert_equal path_to(page_name), current_path
  end
end

Then(/^(?:|I )should have the following query string:$/) do |expected_pairs|
  query = URI.parse(current_url).query
  actual_params = query ? CGI.parse(query) : {}
  expected_params = {}
  expected_pairs.rows_hash.each_pair{|k,v| expected_params[k] = v.split(',')} 

  if actual_params.respond_to? :should
    actual_params.should == expected_params
  else
    assert_equal expected_params, actual_params
  end
end
