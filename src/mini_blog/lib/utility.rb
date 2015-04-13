module Utility
 def self.is_nil_or_not_present_or_not_number_or_zero(param)
  return (!param.is_a? Integer || param == 0 || param.nil? || !param.present?)
 end
end