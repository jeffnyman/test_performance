RSpec.describe TestPerformance do
  before(:all) do
    @browser ||= Watir::Browser.new
  end

  after(:all) do
    @browser.close
  end

  let!(:browser) { @browser }

  it "has a version number" do
    expect(TestPerformance::VERSION).not_to be nil
  end

  it "indicates that default browser (chrome) for watir is supported" do
    browser.goto "google.com"
    expect(browser).to be_performance_supported
  end

  it "returns performance metrics from the browser" do
    browser.goto "google.com"
    expect(browser.performance).to be_an_instance_of(OpenStruct)
  end

  it "gathers summary data from the performance metrics" do
    expect(browser.performance.summary).to include(:app_cache)
    expect(browser.performance.summary).to include(:dns)
    expect(browser.performance.summary).to include(:tcp_connection)
    expect(browser.performance.summary).to include(:request)
    expect(browser.performance.summary).to include(:response)
    expect(browser.performance.summary).to include(:dom_processing)
  end

  it "gathers summary metrics for server time" do
    expect(browser.performance.summary).to include(:response_time)
    expect(browser.performance.summary).to include(:time_to_first_byte)
  end

  it "gathers summary metrics for network plus server time" do
    expect(browser.performance.summary).to include(:response_time)
    expect(browser.performance.summary).to include(:time_to_last_byte)
  end

  it "allows performance via a block" do
    browser.goto "google.com"
    expect {
      browser.with_performance { |performance| performance }
    }.not_to raise_error
  end
end
