= harvest-ruby

http://github.com/bricooke/harvest-ruby

== DESCRIPTION:

Ruby wrapper around the Harvest API 
http://www.getharvest.com/api

== SYNOPSIS:

harvest = Harvest.new("company.harvestapp.com", "email@example.com", "password")

harvest.users[0].last_name
=> "email@example.com"

harvest.users[0].created_at
=> "Fri May 11 15:00:08 EDT 2007"

harvest.projects[0].name
=> "Best Project Ever"

harvest.tasks[0].name
=> "Project Management"

harvest.tasks(59273).name
=> "Project Management"

Fetch all entries and expenses for a project:
harvest.report(5.years.ago, Time.now, :project_id => 6)

or to filter on person:
harvest.report(5.years.ago, Time.now, :person_id => 555)

or to filter on both:
harvest.report(5.years.ago, Time.now, :person_id => 555, :project_id => 6)


== REQUIREMENTS:

activesupport xml-simple

== INSTALL:

sudo gem install harvest-ruby

== TODO:

* Specs
* Document the public API for rdocs

== LICENSE:

(The MIT License)

Copyright (c) 2008 Brian Cooke

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
