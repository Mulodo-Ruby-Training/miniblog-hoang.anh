module ApplicationHelper
  def title(title_name)
    content_for :title, title_name.to_s
  end
end
