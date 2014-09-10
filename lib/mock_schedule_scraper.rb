require 'net/http'
require 'json'
require_relative 'mock_class_info'

class MockScheduleScraper
  # any term that starts with 2 is valid, and class numbers with 5 digits are accepted
  # if those two rules are met, fake info will be provided
  # otherwise, nil is returned
  def get_class_info(term_code, class_number)
    if term_code.start_with?('2') && class_number.length == 5
      MockClassInfo.new('Fake Course', 'MWF')
    else
      nil
    end
  end

  # any term that starts with 2 is valid, and class numbers with 5 digits are accepted
  # if those two rules are met, class numbers starting with 0-4 will return :open, 5-9 will return :closed
  # if class is invalid, nil is returned
  def get_class_status(term_code, class_number)
    if !term_code.start_with?('2') || class_number.length != 5
      nil
    elsif class_number.match(/^[0-4].+/)
      :open
    else
      :closed
    end
  end

  private

  def fetch(term_code, class_number)
    response = Net::HTTP.get_response("localhost", "/course/#{term_code}:#{class_number}", 3001)
    if response.code == "404"
      nil
    else
      json = response.body
      course_info = JSON.parse(json)
    end
  end
end
