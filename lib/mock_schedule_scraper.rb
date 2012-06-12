require 'net/http'
require 'json'
require_relative 'mock_class_info'

class MockScheduleScraper
  def get_class_info(term_code, class_number)
    course_info = fetch(term_code, class_number)

    if course_info.nil?
      nil
    else
      MockClassInfo.new(course_info['name'], course_info['schedule'])
    end
  end


  def get_class_status(term_code, class_number)
    course_info = fetch(term_code, class_number)
    if course_info.nil?
      nil
    elsif course_info['status'] == "Open"
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
