# Model内容修改时异步处理Elasticsearch中的数据
class SearchIndexer < ApplicationJob
  queue_as :search_indexer

  def perform(operation, type, id)
    obj = nil
    type.downcase!

    case type
    when 'topic'
      obj = Topic.without_private.find_by_id(id)
    end

    return false if obj.blank?

    if operation    == 'create'
      obj.__elasticsearch__.index_document
    elsif operation == 'update'
      obj.__elasticsearch__.update_document
    elsif operation == 'delete'
      obj.__elasticsearch__.delete_document
    end
  end
end
