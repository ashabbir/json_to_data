# Python Approach Online already
https://github.com/better/jsonschema2db/blob/master/jsonschema2db.py

## Ruby Approach 1
 - flatten the Nested Json
 - Connect to DB
 - create SELECT INTO Statement from Flatten JSON ( use object_type as
   table name)
 - check for exception If exists .. then do simple insert into

## Ruby Approach 2 (needs RND)
 - create json schema
 - use that to generate Model
 - Run active record migration against the model that will create the DB
   table
 - insert ORM object into table

## Spark Approach (prefered & written in Zepplin Note book can be easily
converted into Spark Submit app)
 - Read Json
 - infer Schema
 - insert into postgresql with append Mode (that should create the table
   if not exists. Use object_type as table name (given below)

-------------

```
//Zepplin NoteBook if u cant load json u can see the code here
//This can be easily converted into a spark pipeline


//paragraph 1
%sh
wget https://repo1.maven.org/maven2/org/postgresql/postgresql/42.1.1/postgresql-42.1.1.jar
mv postgresql-42.1.1.jar /zeppelin/conf/postgresql-42.1.1.jar



//paragraph 2
//load jars into spark
%spark.dep
z.reset()
z.load("/zeppelin/conf/postgresql-42.1.1.jar")


//paragraph 3
//connect to PG
//parse file
//insert into database
//(hoping) append mode will create the data table - if not then create table by parsing JSON schema

%spark
import org.apache.spark.sql.functions._
import spark.implicits._

val inputPath = "<input path where the json data resides>"
val dbName = "<name of psql database>"
val tableName = "<name of the table in the database>"
val userName = "<psql userName>"
val password = "<psql password>"
val host = "<postgres host ip>"
val port = "<postgres port>"
val finalUrl = s"jdbc:postgresql://$host:$port/$dbName"
val input = spark.read.format("json").load(inputPath)
input.
    write.
    format("jdbc").
    mode("Append").
    option("driver", "org.postgresql.Driver").
    option("url", finalUrl).
    option("dbtable", tableName).
    option("user", user).
    option("password", password).
    save()            
```         

----

$docker-compose run app bash

$bundle

$bundle exec irb or bundle exec ruby [FileName].rb

