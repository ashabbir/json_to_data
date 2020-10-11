require 'json'
require 'sequel'
require 'pg'

def flat(hash, results = {}, parent_key = '')
  return results unless hash.kind_of?(Hash)

  hash.keys.each do |key|
    # current_key = "#{parent_key}[#{key}]" # uncomment this if you want to keep parent key as a partof key for flattened hash (csv column name)
    current_key = key
    if hash[key].kind_of?(Hash)
      results = flat(hash[key], results, current_key)
    else
      if hash[key].kind_of?(Array)
        results[current_key] = hash[key].reject(&:empty?).join("; ")
      else
        results[current_key] = hash[key]
      end
    end
  end

  results
end

data = File.read('data/sample.json')
j_data = JSON.parse(data)

flat_data = flat(j_data)

#sequel gem
#DB Connection
DB = Sequel.connect(adapter: :postgres, user: 'dev', password: 'dev', host: 'db', database: 'dev')
#SELECT INTO



