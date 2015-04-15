module Utility
  def self.is_nil_or_not_present_or_not_number_or_zero(param)
    return (!param.is_a? Integer || param == 0 || param.nil? || !param.present?)
  end
  def self.split_base64(string_encode)
    if string_encode.match(%r{^data:(.*?);(.*?),(.*)$})
      return {
        type: $1, # "image/png"
        name: $2, # "name original"
        data: $3, # data string
        extension: $1.split('/')[1] # "extention"
      }
    end 
  end
end