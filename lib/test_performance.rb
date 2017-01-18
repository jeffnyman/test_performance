require "ostruct"
require "test_performance/version"

module Watir # TestPerformance
  class PerformanceData
    def initialize(data)
      @data = data
    end

    def mapping
      hash = {}
      @data.each_key do |key|
        next if key == '__fxdriver_unwrapped'

        hash[key.to_sym] = {}

        next unless @data[key].respond_to? :each

        # BREAK OUT ALL IN THIS LOOP INTO METHOD?
        # WOULD HAVE TO PASS hash AND key.
        # WOULD HAVE TO RETURN hash.
        data_mapper(hash, key)
        # @data[key].each do |k, v|
        #  next if k == '__fxdriver_unwrapped'
        #  hash[key.to_sym][underscored(k).to_sym] = v
        # end
      end

      hash[:summary] = {}

      gather_summary_metrics(hash)

      OpenStruct.new(hash)
    end

    private

    def data_mapper(hash, key)
      @data[key].each do |k, v|
        next if k == '__fxdriver_unwrapped'
        hash[key.to_sym][underscored(k).to_sym] = v
      end
      hash
    end

    def gather_summary_metrics(hash)
      summary_redirect(hash)
      summary_app_cache(hash)
      summary_dns(hash)
      summary_tcp_connection(hash)
      summary_tcp_connection_secure(hash)
      summary_request(hash)
      summary_response(hash)
      summary_dom_processing(hash)
      summary_time_to_first_byte(hash)
      summary_time_to_last_byte(hash)
      summary_response_time(hash)
    end

    def summary_redirect(hash)
      return if hash[:timing][:redirect_end] <= 0
      hash[:summary][:redirect] =
        hash[:timing][:redirect_end] - hash[:timing][:redirect_start]
    end

    def summary_app_cache(hash)
      return if hash[:timing][:fetch_start] <= 0
      hash[:summary][:app_cache] =
        hash[:timing][:domain_lookup_start] - hash[:timing][:fetch_start]
    end

    def summary_dns(hash)
      return if hash[:timing][:domain_lookup_start] <= 0
      hash[:summary][:dns] =
        hash[:timing][:domain_lookup_end] - hash[:timing][:domain_lookup_start]
    end

    def summary_tcp_connection(hash)
      return if hash[:timing][:connect_start] <= 0
      hash[:summary][:tcp_connection] =
        hash[:timing][:connect_end] - hash[:timing][:connect_start]
    end

    def summary_tcp_connection_secure(hash)
      return if hash[:timing][:secure_connection_start].nil? &&
                hash[:timing][:secure_connection_start] <= 0

      hash[:summary][:tcp_connection_secure] =
        hash[:timing][:connect_end] - hash[:timing][:secure_connection_start]
    end

    def summary_request(hash)
      return if hash[:timing][:request_start] <= 0
      hash[:summary][:request] =
        hash[:timing][:response_start] - hash[:timing][:request_start]
    end

    def summary_response(hash)
      return if hash[:timing][:response_start] <= 0
      hash[:summary][:response] =
        hash[:timing][:response_end] - hash[:timing][:response_start]
    end

    def summary_dom_processing(hash)
      return if hash[:timing][:dom_loading] <= 0
      hash[:summary][:dom_processing] =
        hash[:timing][:dom_content_loaded_event_start] -
        hash[:timing][:dom_loading]
    end

    def summary_time_to_first_byte(hash)
      return if hash[:timing][:domain_lookup_start] <= 0
      hash[:summary][:time_to_first_byte] =
        hash[:timing][:response_start] - hash[:timing][:domain_lookup_start]
    end

    def summary_time_to_last_byte(hash)
      return if hash[:timing][:domain_lookup_start] <= 0
      hash[:summary][:time_to_last_byte] =
        hash[:timing][:response_end] - hash[:timing][:domain_lookup_start]
    end

    def summary_response_time(hash)
      hash[:summary][:response_time] =
        latest_timestamp(hash) - earliest_timestamp(hash)
    end

    def underscored(camel_cased_word)
      word = camel_cased_word.to_s.dup
      word.gsub!(/::/, '/')
      word.gsub!(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end

    def earliest_timestamp(hash)
      return hash[:timing][:navigation_start] if hash[:timing][:navigation_start] > 0
      return hash[:timing][:redirect_start] if hash[:timing][:redirect_start] > 0
      return hash[:timing][:redirect_end] if hash[:timing][:redirect_end] > 0
      return hash[:timing][:fetch_start] if hash[:timing][:fetch_start] > 0
    end

    def latest_timestamp(hash)
      return hash[:timing][:load_event_end] if hash[:timing][:load_event_end] > 0
      return hash[:timing][:load_event_start] if hash[:timing][:load_event_start] > 0
      return hash[:timing][:dom_complete] if hash[:timing][:dom_complete] > 0
      return hash[:timing][:dom_content_loaded_event_end] if hash[:timing][:dom_content_loaded_event_end] > 0
      return hash[:timing][:dom_content_loaded_event_start] if hash[:timing][:dom_content_loaded_event_start] > 0
      return hash[:timing][:dom_interactive] if hash[:timing][:dom_interactive] > 0
      return hash[:timing][:response_end] if hash[:timing][:response_end] > 0
    end
  end

  class Browser
    def performance
      data =
        case driver.browser
          when :internet_explorer
            Object::JSON.parse(driver.execute_script(performance_test_for_ie))
          else
            driver.execute_script(performance_test)
        end
      performance_error if data.nil?
      PerformanceData.new(data).mapping
    end

    def with_performance
      yield PerformanceData.new(performance_data).mapping if performance_supported?
    end

    def performance_data
      driver.execute_script(performance_test)
    end

    alias performance_supported? performance_data

    def performance_error
      raise "Unable to collect performance metrics from the current "\
        "browser. Make sure the browser you are using supports collecting "\
        "performance metrics."
    end

    def performance_test
      "return window.performance || "\
        "window.webkitPerformance || window.mozPerformance || "\
        "window.msPerformance;"
    end

    def performance_test_for_ie
      "return JSON.stringify(window.performance.toJSON());"
    end
  end
end
