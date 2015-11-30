require 'phantomjs'
require 'capybara/poltergeist'
require 'command_line_reporter'
require 'mail'

## How do I even run this ?
# Well, here's a few ways how:
# This one will send me an email (janjos@weddingwire.com) with the results
# ruby capy.rb
# This one will debug/show a lot of output for each request
# ruby capy.rb debug
# This one will print it out in a nice table for your own reference, and not email
# ruby capy.rb noemail
# This one is self-explanatory (but needs to have debug as argv0, cuz im a lazy programmer)
# ruby capy.rb debug noemail 
# Happy Load testing!

class LoadTest
	include CommandLineReporter

	def initialize
		@lol_array = Array.new
		@results = Array.new
	end

	def testable_urls
		[
			{   type: 'business_name',
				url: 'http://mantis.pod.weddingwire.com/shared/search?l=y&cid=y&hp=y&vss=y&name=Steve&geo=20815&commit=Find+Vendors',
				selector: '.testing-catalog-header'
			},
			{
				type: 'landing_page',
				url: 'http://mantis.pod.weddingwire.com/ng/vendor-reviews',
				selector: '.testing-find-vendors'
			},
			{ 
				type: 'catalog_photo',
				url: 'http://mantis.pod.weddingwire.com/shared/search?cid=11&geo=20815&geosr=20910&page=1&sort=1&view_type=photo', 
				selector: '.testing-vendor-photo-tile'
			}, 
			{
				type: 'catalog_list',
				url: 'http://mantis.pod.weddingwire.com/shared/search?cid=11&geo=20815&geosr=20910&page=1&sort=1&view_type=list',
				selector: '.testing-vendor-list-tile'
			},
			{
				type: 'catalog_list_filter',
				url: 'http://mantis.pod.weddingwire.com/shared/search?cid=11&geo=20815&geosr=20910&page=1&sort=1&view_type=list',
				selector: '.testing-vendor-photo-tile'
			}
		]


	end

	def aggregate_results(type, difference, net_traffic)

		@lol_array << {type: type, time: difference, net_traffic_size: net_traffic}
	end

	def run_test(type, url, selector_reference, debug = false)
		begin
			Capybara.javascript_driver = :poltergeist
			browser = Capybara::Session.new(:poltergeist, timeout: 60)
			start_time = Time.now
			puts "Time: #{start_time}" if debug
			browser.visit url
			puts "#{type} currently executing..." if debug
			browser.has_css?(selector_reference)
			puts "Found element on ..." if debug
			puts url if debug
			print '.' unless debug
			if type == 'catalog_list_filter'
				browser.all('label', :text => '100-199').first.click
				browser.has_css?('.testing-vendor-photo-tile')
			end
			puts "....checking network!" if debug
			network_traffic_size = browser.driver.network_traffic.size
			puts "# of requests: #{network_traffic_size}" if debug
			first_call_time = browser.driver.network_traffic.first.time
			last_call_time = browser.driver.network_traffic.last.time
			puts "Time for first call: #{first_call_time}"  if debug
			puts "Time for last call: #{last_call_time}"  if debug
			difference = last_call_time - first_call_time
			puts "Difference: #{difference}".yellow  if debug
			puts "Before opening browser until page load -> #{last_call_time - start_time}"  if debug
			aggregate_results(type, difference, network_traffic_size)
			browser.driver.quit
		rescue Capybara::Poltergeist::TimeoutError
			print 'F'
			browser.driver.quit
			aggregate_results("#{type}-errored", 0, 0)
		end
	end

	def run	
		debug = true if ARGV[0] == 'debug'
		@noemail = true if (ARGV[0] == 'noemail') || (ARGV[1] == 'noemail')

		runs_per_page = 5
		urls = testable_urls
		result_array = Array.new
		urls.each do |hash|
			@temp_results = Array.new
			runs_per_page.times{
				run_test(hash[:type], hash[:url], hash[:selector], debug)
			}
			@lol_array.each do |result|
				@temp_results << result[:time]
			end
			average = @temp_results.reduce(:+).to_f / @temp_results.size
			result_array << [hash[:type], average.round(2)]
		end
		puts " ~ "
		if @noemail
			table(border: true) do
				row do
					column('Type', width: 20)
					column('Avg Duration', width: 20, align: 'right')
					column('Attempts', width: 10)
				end
				result_array.each do |x|
					row do
						column(x.first)
						column(x.last, align: 'right')
						column(runs_per_page, align: 'right')
					end
				end
			end
		else
			return @results = result_array
		end
	end



	def do_email_stuff
		body_text = @results.to_s
		mail = Mail.new do
			from 'loadtestresults@fakedomain.com'
			to 'janjos@weddingwire.com'
			subject 'Load test results'
			body body_text
		end
		mail.delivery_method :sendmail
		mail.deliver
	end

	def run_this_crap
		run
		do_email_stuff unless @noemail
	end
end

LoadTest.new.run_this_crap

