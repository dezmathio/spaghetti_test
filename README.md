# spaghetti_test
custom script to load test a couple urls

# How do I even run this ?

 Well, here's a few ways how:
 
 This one will send me an email (janjos@weddingwire.com) with the results
 
 `bundle exec ruby capy.rb`
 
 This one will debug/show a lot of output for each request
 
 `bundle exec ruby capy.rb debug`
 
 This one will print it out in a nice table for your own reference, and not email
 
 `bundle exec ruby capy.rb noemail`
 
 This one is self-explanatory (but needs to have debug as argv0, cuz im a lazy programmer)
 
 `bundle exec ruby capy.rb debug noemail`
 
 Happy "load" testing!
