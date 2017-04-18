# Elasticsearch
module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    after_commit on: [:create] do
      SearchIndexer.perform_later('create', self.class.name, self.id)
    end

    after_commit on: [:update] do
      SearchIndexer.perform_later('update', self.class.name, self.id)
    end

    after_commit on: [:destroy] do
      SearchIndexer.perform_later('delete', self.class.name, self.id)
    end
  end
end
