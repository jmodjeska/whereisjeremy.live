# frozen_string_literal: true

require 'aws-sdk-amplify'
require_relative 'lib/manage_secrets'

# This is a CLI script to run locally. It is not part of the Amplify build.

read_mode = false

# CLI input
new_loc = [ARGV[0], ARGV[1], ARGV[2]]
read_mode = true unless new_loc.all? { |e| !e.nil? }
puts "Usage: '2024-01-01 2024-01-09 City' to add a location" if read_mode

# Config
app_id = 'd1okc9dk88vz1z'
branch_name = 'main'
amplify_client = Aws::Amplify::Client.new(region: 'us-west-2')
secret_name = 'whereisjeremy-locations'

s = ManageSecrets.new(secret_name)

def iterate_locations(locations)
  locations.each do |loc|
    start_date, end_date, city = loc
    puts "Start: #{start_date}, End: #{end_date}, City: #{city}"
  end
end

# Read existing locations from Secrets Manager
puts '-=> Existing locations:'
locations = s.read_secret
iterate_locations(locations)
exit if read_mode

# Append the new location
puts '-=> Adding new location'
locations << new_loc
update_event = s.update_secret(locations.to_s)
abort '-=> Error saving to Secrets Manager' unless update_event

# Update secret
puts '-=> Success! Updated Locations:'
updated_locations = s.read_secret
iterate_locations(updated_locations)

# Rebuild the site
puts '-=> Starting Amplify build ...'
response = amplify_client.start_job(
  app_id: app_id,
  branch_name: branch_name,
  job_type: 'RELEASE'
)
puts "-=> Started Amplify build. Job ID: #{response.job_summary.job_id}."
