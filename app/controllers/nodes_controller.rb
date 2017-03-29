class NodesController < ApplicationController

  def show
    node_id = params[:id]

    @topics = Topic.where(node_id: node_id).paginate(page: params[:page], :per_page => 10).order('created_at DESC')
    render '/topics/index'
  end

end
