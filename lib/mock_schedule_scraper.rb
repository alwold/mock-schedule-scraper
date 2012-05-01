require 'net/http'
require 'json'

class MockScheduleScraper
  def get_class_info(term_code, class_number)
    course_info = fetch(term_code, class_number)

    MockClassInfo.new(course_info['name'], course_info['schedule'])
  end


  def get_class_status(term_code, class_number)
    course_info = fetch(term_code, class_number)
    if course_info = "Open"
      :open
    else
      :closed
    end
  end

  private

  def fetch(term_code, class_number)
    json = Net::HTTP.get("localhost", "/course/#{term_code}:#{class_number}", 3001)
    course_info = JSON.parse(json)
  end
end