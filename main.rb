# extract phone number from one file.
# currently support 2 commonly used phone number formats in thailand "08x xxx xxxx" and "02 xxx xxxxx"
# @param [String] path path to the file
# @return [Array<String>] array of phone numbers extracted from the file. the strings of phone numbers will be sanitzed, containing only numbers and no any special characters (e.g. spaces or dashes)
def extract_one_file path
    content = File.read(path)
    tels = content.scan(/(((08[0-9])|(02))[- ]?[0-9][0-9][0-9][- ]?[0-9][0-9][0-9][0-9])/).collect{|tel| tel.first}
    sanitized_tels = tels.collect{|tel| tel.scan(/[0-9]*/).join }
    return sanitized_tels
end

# have a hash bucket to store phone numbers so that we can store *distinct* phone numbers with only O(1) each store
tel_bucket = {}

# iterate through all HTML files in the directory
Dir['{test-html/**/*.htm,test-html/**/*.html}'].each do |path|
    # extract from current file
    tels = extract_one_file(path)
    
    # store in bucket
    for tel in tels 
        tel_bucket[tel] = true
    end
end

# output the *distinct* phone numbers extracted
for tel in tel_bucket.keys
    puts tel
end
