class PicturesController < ApplicationController
  load_and_authorize_resource

  def index
    @pictures = Picture.paginate(page: params[:page], :per_page => 10).order('created_at DESC')
  end

  def new
    @picture = Picture.new
  end

  def create
    # @picture = Picture.new(picture_params)
    # @picture.user_id = current_user.id

    # if @picture.save
    #   redirect_to(picture_path(@picture), notice: I18n.t('common.create_success'))
    # else
    #   render action: 'new'
    # end

    # 将上传的多张图片分别保存到一条记录中
    save_images = []
    params[:picture][:image].each do |i|
      image_info = { image: [i], user_id: current_user.id }
      save_images << image_info
    end

    if Picture.create(save_images)
      redirect_to(pictures_path, notice: I18n.t('common.create_success'))
    else
      render action: 'new'
    end
  end

  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy
    redirect_to(pictures_path, notice: t('common.delete_success'))
  end

  private

  def picture_params
    params.require(:picture).permit( {image: []} )
  end

end