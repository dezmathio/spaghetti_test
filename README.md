# spaghetti_test
custom script to load test a couple urls

# How do I even run this ?

 Well, here's a few ways how:
 
 This one will send me an email (janjos@weddingwire.com) with the results
 
 `bundle exec ruby loader.rb`
 
 This one will debug/show a lot of output for each request
 
 `bundle exec ruby loader.rb --debug`
 
 This one will print it out in a nice table for your own reference, and not email
 
 `bundle exec ruby loader.rb --noemail`
 
 This one is self-explanatory
 
 `bundle exec ruby loader.rb -d -n`
 
 Happy "load" testing!
