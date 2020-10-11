require 'sequel'
require 'pg'
require 'json-schema-generator'
require 'json'
require 'pry'
require 'json_schema_tools'


DB = Sequel.connect(adapter: :postgres, user: 'dev', password: 'dev', host: 'db', database: 'dev')


#assumption that we will have type of object in json
file = 'data/sample.json'
parsed_json = JSON.parse(File.read(file))
type_key = parsed_json.keys.select { |x| x.include? 'type' }
json_type = parsed_json[type_key.first].to_s.downcase


#https://github.com/salesking/json_schema_tools
json_schema = JSON.parse(JSON::SchemaGenerator.generate file, File.read(file), {:schema_version => 'draft3'})
File.write("schema/#{json_type}.json", json_schema.to_json)

SchemaTools.schema_path = 'schema/'
# this should blow up sjaon Schema into class
SchemaTools::KlassFactory.build

job = Job.from_json(json_type)
#  ... Timeup
#  To create Migration (db migration) below reference
#  https://railsdrop.com/2015/08/12/create-a-migration-file-dynamically-in-rails-4-0-from-a-rake-task-or-lib-file/

## once migration is done insert data
