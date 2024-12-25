# frozen_string_literal: true

require 'date'
require_relative 'lib/manage_secrets'

execution_dir = 'whereisjeremy.live'
current_dir = File.basename(Dir.getwd)
build_dir = 'build/site'

unless execution_dir == current_dir
  abort 'EXIT: Call the build script from the root project directory, ' \
    "#{execution_dir} (currently calling from '#{current_dir})'."
end

# Config
@today = Date.today.to_s
html = File.read('index_template.html')

# Get location info from Secrets Manager
# Yes I am aware these aren't really secrets if I'm putting them on a website
@locations = ManageSecrets.new('whereisjeremy-locations').read_secret
@default_city = ManageSecrets.new('whereisjeremy-default-city').read_secret
@watch_city = ManageSecrets.new('whereisjeremy-watch-city').read_secret

# Replace current city
def current_city
  @locations.each do |r|
    return r[2] if @today.between?(r[0], r[1])
  end
  return @default_city
end
html.gsub!('<!-- CURRENT_LOCATION -->', current_city)

# Replace watch city
html.gsub!('<!-- WATCH_CITY -->', @watch_city)

# Replace date for watch city
@next_date = 'No trips scheduled :('
@locations.sort_by { |start, _end, _city| Date.parse(start) }.each do |loc|
  next if loc[0] < @today
  next unless loc[2] == @watch_city
  @next_date = Date.parse(loc[0]).strftime('%B %e, %Y')
  break
end
html.gsub!('<!-- NEXT_DATE -->', @next_date)

# Write index file
File.write("#{build_dir}/index.html", html)
