# spaghetti_test
custom script to load test a couple urls

# How do I even run this ?

First off, you'll need to install phantomjs

`brew install phantomjs`

NOTE: If you're on OSX El Capitan you'll need to do

`brew install npm`

`npm install phantom phantomjs -g`

After that, you should set the value of `RECEIVING_EMAIL` in your `.env` file in the directory to be your own email.
Once you're done with that, modify with the `urls.json` to hit the url you'd like, and also to know which selector to check so that it waits until the page is loaded.

 Well, here's a few ways to run this:
 
 This one will send me an email to ENV["RECEIVING_EMAIL"] with the results
 
 `bundle exec ruby loader.rb`
 
 This one will debug/show a lot of output for each request
 
 `bundle exec ruby loader.rb --debug`
 
 This one will print it out in a nice table for your own reference, and not email
 
 `bundle exec ruby loader.rb --noemail`
 
 This one is self-explanatory
 
 `bundle exec ruby loader.rb -d -n`
 
 Happy "load" testing!
