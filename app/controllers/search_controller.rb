class SearchController < ApplicationController

  def index
    search_params = {
      query: {
        simple_query_string: {
          query: params[:q],
          fields: ['title', 'body', '*.title'],
          default_operator: 'and'
        }
      },
      highlight: {
        pre_tags: ['<em>'],
        post_tags: ['</em>'],
        fields: {
          title: {},
          body: {},
          '*.title': {}
        }
      }
    }

    @result = Elasticsearch::Model.search(search_params, [Topic]).paginate(page: params[:page], per_page: 10)
  end

end