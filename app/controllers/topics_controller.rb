class TopicsController < ApplicationController
  load_and_authorize_resource only: [:new, :edit, :create, :update, :destroy]

  def index
    if current_user.blank?
      # 只获取所有可见的文章信息
      node_ids = Node.where(publish: true).pluck(:id)
      @topics = Topic.includes(:node).where("node_id in (:node_ids)", node_ids: node_ids).paginate(page: params[:page], :per_page => 10).order('created_at DESC')
    else
      @topics = Topic.paginate(page: params[:page], :per_page => 10).order('created_at DESC')
    end
  end

  def show
    @threads = []

    @topic = Topic.unscoped.includes(:user).find(params[:id])

    # 阅读量自动加1
    @threads << Thread.new do
      @topic.hits.incr(1)
    end

    @threads.each(&:join)

    render_404 if @topic.deleted?
  end

  def new
    @nodes_select = Node.all.collect { |node| [node.name, node.id] }
    @topic = Topic.new
  end

  def edit
    @nodes_select = Node.all.collect { |node| [node.name, node.id] }
    @topic = Topic.find_by_id(params[:id])
  end

  def create
    @nodes_select = Node.all.collect { |node| [node.name, node.id] }
    @topic = Topic.new(topic_params)
    @topic.user_id = current_user.id

    if @topic.save
      redirect_to(topic_path(@topic), notice: I18n.t('common.create_success'))
    else
      render action: 'new'
    end
  end

  def update
    @topic = Topic.find(params[:id])

    if @topic.update_attributes(topic_params)
      redirect_to(topic_path(@topic), notice: I18n.t('common.update_success'))
    else
      render action: 'edit'
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
    redirect_to(topics_path, notice: t('common.delete_success'))
  end

  private

  def topic_params
    params.require(:topic).permit(:title, :body, :node_id)
  end

end