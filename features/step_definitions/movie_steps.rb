# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create! movie unless Movie.find :first, :conditions => movie
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  regexp = /#{e1}.*#{e2}/m
  assert page.body =~ regexp, "#{e1} should be before #{e2}"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(/,\s*/).each do |rating|
    steps %Q{
      When I #{'un' if uncheck}check "ratings[#{rating}]"
    } 
  end
end

Then /I should see all of the movies/ do
  assert find('#movielist').all('tr').count == Movie.count, 'Expected all movies'
end

Then /I should( not)? see the following movies/ do |unseen, movies_table|
  movies_table.hashes.each do |movie|
    steps %Q{ Then I should#{" not" if unseen} see "#{movie[:title]}" }
  end
end

When /I filter by the following ratings: (.*)/ do |rating_list|
  steps %Q{
    When I check the following ratings: #{rating_list}
    And I press "Refresh"
  }
end