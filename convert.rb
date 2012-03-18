require 'active_support/all'
require 'csv'

$stdout.sync=true

splashid_filename = ARGV[0].blank? ? 'SplashID Export.vid' : ARGV[0]
strip_filename = ARGV[1].blank? ? 'strip-import.csv' : ARGV[1]

unless File.exists?(splashid_filename)
  $stderr.print "Error: File #{splashid_filename} does not exist.\n"
  $stderr.print "Usage: ruby #{$0} ['SplashID Export.vid'] [strip-import.csv]\n"
  raise
end

puts "Examining #{splashid_filename}..."

idx = 0
# we need to be able to look-up categories from entries, so we'll have to give them keys
categories = {}
entries = []
# a master list of all fields, uniqued
fields = []
# this is fantastic: http://ruby-doc.org/stdlib-1.9.2/libdoc/csv/rdoc/CSV.html
CSV.foreach(splashid_filename) do |row|
  # we skip the first two rows:
  # SplashID vID File -v3.0
  # F
  if idx == 0 || idx == 1
    # remember to up the idx!
    idx += 1
    next
  end
  
  # if the first column contains a T, it's a category definition, e.g.
  # T,21,Web Logins,Description,Username,Password,URL,Field 5,Field 6,Field 7,Field 8,Field 9,Date Mod,4,
  if row[0] == 'T'
    # puts "Category: #{row[2]}"
    key = row[1].to_sym
    categories[key] = {
      :id       => row[1],
      :name     => row[2],
      :fields   => row[4..11]
    }
    categories[key][:fields].each do |f|
      fields << f unless fields.include?(f)
    end
  else # Entry row
    ckey    = row[1].to_sym
    efields = {}
    row[3..10].each_with_index do |field, idx|
      unless field.blank?
        field_name = categories[ckey][:fields][idx]
        efields[field_name] = field
      end
    end
    entry = {
      :name     => row[2],
      :category => categories[ckey][:name],
      :fields   => efields
    }
    entries << entry
  end
  
  idx += 1
end

fields = fields.sort
puts "We've found #{entries.count} entries, composing output..."
CSV.open(strip_filename, "wb") do |csv|
  # start with the header row: Category, Entry, Fields...,
  csv << [ 'Category', 'Entry' ].concat(fields)
  entries.each do |entry|
    row = [ entry[:category], entry[:name] ]
    # for each field type, add the value if the entry has one, or emit a blank
    fields.each do |f|
      if entry[:fields][f].blank?
        row << ''
      else 
        row << entry[:fields][f]
      end
    end
    csv << row
  end
end
puts "Your file #{strip_filename} is ready for import into STRIP!"

