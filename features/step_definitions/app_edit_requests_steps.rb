When /^(?:|I )follow the App Edit Request with id (.+)$/ do |id|
  visit appeditrequest_path(id)
end
