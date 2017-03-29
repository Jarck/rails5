module MarkdownBody
  extend ActiveSupport::Concern
  include ActionView::Helpers::SanitizeHelper
  include ApplicationHelper

  included do
    before_save :markdown_body
    scope :without_body, -> { without(:body) }
  end

  private

  # 将Markdown内容转换成HTML
  def markdown_body
    if self.body_changed?
      self.body_html = markdown(body)
    end
  end
end
