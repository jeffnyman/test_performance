# TestPerformance

[![Gem Version](https://badge.fury.io/rb/test_performance.svg)](http://badge.fury.io/rb/test_performance)
[![License](http://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/jeffnyman/test_performance/blob/master/LICENSE.txt)

[![Dependency Status](https://gemnasium.com/jeffnyman/test_performance.png)](https://gemnasium.com/jeffnyman/test_performance)

This gem collects and summarizes metrics that have been specified as part of the [W3C Navigation web performance specifications](http://w3c.github.io/navigation-timing/). This requires you to be using Watir as well as a browser that supports the specification.

All of the metrics provided are those indicated by the [processing model](http://w3c.github.io/navigation-timing/#processing-model) of the public specification. All summary times provided are in milliseconds.

## Installation

To get the latest stable release, add this line to your application's Gemfile:

```ruby
gem 'test_performance'
```

And then include it in your bundle:

    $ bundle

You can also install TestPerformance just as you would any other gem:

    $ gem install test_performance

## Usage

The simplest use case is to use Watir driver instance, perform some actions in a browser via the API, and then call the `performance` method, as such:

```ruby
require "test_performance"
require "watir"

browser = Watir::Browser.new
browser.goto "google.com"
p browser.performance
browser.close
```

The output you get should look like this:

```
  {
    :summary => {
                   :redirect=>0,
                  :app_cache=>0,
                        :dns=>0,
            :tcp_connection=>982,
     :tcp_connection_secure=>721,
                  :request=>1222,
                    :response=>4,
           :dom_processing=>4293,
            :response_time=>7298,
       :time_to_first_byte=>2205,
        :time_to_last_byte=>2209
    },
    :navigation => {
                     :type => 0,
        :type_back_forward => 2,
           :redirect_count => 0,
            :type_reserved => 255,
            :type_navigate => 0,
              :type_reload => 1
    },
        :memory => {
        :total_js_heap_size => 0,
        :js_heap_size_limit => 0,
         :used_js_heap_size => 0
    },
        :timing => {
                   :domain_lookup_start => 1303180421599,
                        :load_event_end => 0,
                           :connect_end => 1303180421642,
                          :response_end => 1303180421853,
                           :dom_loading => 1303180421840,
                      :navigation_start => 0,
                          :redirect_end => 0,
                    :unload_event_start => 0,
               :secure_connection_start => 0,
                         :connect_start => 1303180421600,
          :dom_content_loaded_event_end => 1303180421934,
                     :domain_lookup_end => 1303180421600,
                       :dom_interactive => 1303180421934,
                      :load_event_start => 0,
                         :request_start => 1303180421642,
                        :response_start => 1303180421838,
                          :dom_complete => 0,
                           :fetch_start => 1303180421598,
        :dom_content_loaded_event_start => 1303180421934,
                        :redirect_start => 0,
                      :unload_event_end => 0
    }
  }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec:all` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/jeffnyman/test_performance](https://github.com/jeffnyman/test_performance). The testing ecosystem of Ruby is very large and this project is intended to be a welcoming arena for collaboration on yet another testing tool. As such, contributors are very much welcome but are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

To contribute to TestPerformance:

1. [Fork the project](http://gun.io/blog/how-to-github-fork-branch-and-pull-request/).
2. Create your feature branch. (`git checkout -b my-new-feature`)
3. Commit your changes. (`git commit -am 'new feature'`)
4. Push the branch. (`git push origin my-new-feature`)
5. Create a new [pull request](https://help.github.com/articles/using-pull-requests).

## Author

* [Jeff Nyman](http://testerstories.com)

## Credits

This code is based upon the [watir-webdriver-performance](https://github.com/90kts/watir-webdriver-performance) gem. That gem has not been maintained in some time so I wanted to create a version that was updated for the latest changes in Watir as well as provide more modular code to allow for better evolution of the performance gathering as well as potentially providing this mechanism outside the context of Watir, hence the name change.

## License

TestPerformance is distributed under the [MIT](http://www.opensource.org/licenses/MIT) license.
See the [LICENSE](https://github.com/jeffnyman/test_performance/blob/master/LICENSE.txt) file for details.
