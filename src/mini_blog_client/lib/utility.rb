module Utility
  def self.is_nil_or_not_present_or_not_number_or_zero(param)
    return (!param.is_a? Integer || param == 0 || param.nil? || !param.present?)
  end
  def self.send_request_to_host_api(method,url,data_input=nil)
    case method.to_s.downcase    
    when "get"
      response = Net::HTTP.get(URI.parse(url.to_s))
      data_output = JSON.parse(response)
      return data_output
    when "post"
      resp = Net::HTTP.post_form(URI.parse(url.to_s),data_input)
      data_output = JSON.parse(resp.body)
      return data_output
    when "put"
      uri = URI.parse(url.to_s)
      http = Net::HTTP.new(uri.host,uri.port)
      request = Net::HTTP::Put.new(uri.path)
      request.set_form_data(data_input)
      response = http.request(request)
      data_output = JSON.parse(response.body)
      return data_output
    when "delete"
      uri = URI.parse(url.to_s)
      http = Net::HTTP.new(uri.host,uri.port)
      request = Net::HTTP::Delete.new(uri.path)
      request.set_form_data(data_input)
      response = http.request(request)
      data_output = JSON.parse(response.body)
      return data_output
    else
      response = Net::HTTP.get(URI.parse(url.to_s))
      data_output = JSON.parse(response)
      return data_output
    end
  end
  def self.remove_style_and_script_tag(input_content)
    if !input_content.nil? && input_content.length >= 5
      output_content = Nokogiri::HTML(input_content)
      output_content.xpath("//script").remove
      output_content.xpath("//style").remove
      output_content.xpath("@style|.//@style").remove
      return output_content
    end
  end
end