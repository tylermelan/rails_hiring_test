# setup your ridings and polls
require 'csv'

if Riding.all.size == 0
  puts "Creating ridings..."
  riding_count = 0

  CSV.foreach(Rails.root.join("lib/seeds/ridings.csv"), headers: true) do |row|
    Riding.create!(
      riding_code: row["riding_code"].to_i,
      name: row["riding_name"],
      province: row["province"],
    )
    riding_count +=1
    printf("\rCreated %d ridings", riding_count)
  end
else
  puts "Ridings already exist. Skipping."
end

if Poll.all.size == 0
  puts ""
  puts "Creating polls..."
  poll_count = 0

  CSV.foreach(Rails.root.join("lib/seeds/polls.csv"), headers: true) do |row|
    riding = Riding.find_by(riding_code: row["riding_code"].to_i)
    Poll.create!(
      riding: riding,
      number: row["poll_number"]
    )
    poll_count +=1
    printf("\rCreated %d polls", poll_count)
  end
else
  puts "Polls already exist. Skipping."
end

if PollingLocation.all.size == 0
  puts ""
  puts "Creating polling locations..."
  location_count = 0

  CSV.foreach(Rails.root.join("lib/seeds/polling_locations.csv"), headers: true) do |row| 
    riding = Riding.find_by(riding_code: row["riding_code"].to_i)
    poll = Poll.find_by(riding: riding, number: row["poll_number"])

    polling_location = PollingLocation.find_or_create_by(
      riding: riding,
      title: row["title"], 
      address: row["address"],
      city: row["city"],
      postal_code: row["postal_code"]
    )

    poll.update(polling_location: polling_location)
    
    location_count +=1
    printf("\rCreated %d polling locations", location_count)
  end
  else
    puts "Polling locations already exist. Skipping."
end