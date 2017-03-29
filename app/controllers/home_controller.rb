class HomeController < ApplicationController

  def index
    @last_created_topics = Topic.order('created_at DESC').limit(10)

    @last_updated_topics = Topic.order('updated_at DESC').limit(10)
  end

end
