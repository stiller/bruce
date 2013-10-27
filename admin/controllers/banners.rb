Bruce::Admin.controllers :banners do
  get :index do
    @title = "Banners"
    @banners = Banner.all
    render 'banners/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'banner')
    @banner = Banner.new
    render 'banners/new'
  end

  post :create do
    @banner = Banner.new(params[:banner])
    if @banner.save
      @title = pat(:create_title, :model => "banner #{@banner.id}")
      flash[:success] = pat(:create_success, :model => 'Banner')
      params[:save_and_continue] ? redirect(url(:banners, :index)) : redirect(url(:banners, :edit, :id => @banner.id))
    else
      @title = pat(:create_title, :model => 'banner')
      flash.now[:error] = pat(:create_error, :model => 'banner')
      render 'banners/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "banner #{params[:id]}")
    @banner = Banner.find(params[:id])
    if @banner
      render 'banners/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'banner', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "banner #{params[:id]}")
    @banner = Banner.find(params[:id])
    if @banner
      if @banner.update_attributes(params[:banner])
        flash[:success] = pat(:update_success, :model => 'Banner', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:banners, :index)) :
          redirect(url(:banners, :edit, :id => @banner.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'banner')
        render 'banners/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'banner', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Banners"
    banner = Banner.find(params[:id])
    if banner
      if banner.destroy
        flash[:success] = pat(:delete_success, :model => 'Banner', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'banner')
      end
      redirect url(:banners, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'banner', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Banners"
    unless params[:banner_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'banner')
      redirect(url(:banners, :index))
    end
    ids = params[:banner_ids].split(',').map(&:strip)
    banners = Banner.find(ids)
    
    if Banner.destroy banners
    
      flash[:success] = pat(:destroy_many_success, :model => 'Banners', :ids => "#{ids.to_sentence}")
    end
    redirect url(:banners, :index)
  end
end
