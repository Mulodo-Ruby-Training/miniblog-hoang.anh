module V1
  class FileStringUpload < StringIO
    attr_accessor :original_filename, :content_type
  end
end