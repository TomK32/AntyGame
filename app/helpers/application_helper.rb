# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  attr_accessor :page_title
  def page_title
    @page_title
  end
  def title_meta
    [t(:'app.title'),page_title].compact.join(' // ')
  end
end
