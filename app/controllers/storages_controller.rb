class StoragesController < ApplicationController

  hobo_model_controller

  auto_actions :all
  respond_to :js, :html

  def index
        @c_summ  = 0
        @k_summ = 0
        @i = 0
        @asum = 0
    # FILTERS
      #Save param to session
      %w(pr_name location_good filial_name).each do |key|                                                                                                           
         if not params[key].nil?; session[key] = params[key]
           elsif not session[key].nil?; params[key] = session[key]
           end
         params.delete(key) if params[key].blank?
     end
      #---

    @storages = Storage.
      search(params[:search], :id, :codeg, :name, :cena ).
      order_by(parse_sort_param(:id, :name, :codeg, :cena, :count))

    @storages = @storages.where("filial_id like ?", params[:filial_name]) unless params[:filial_name].blank?
    @storages = @storages.where("location_good like ?", params[:location_good]) unless params[:location_good].blank?

    @storages = @storages.where("pr_name like ?", params[:pr_name]) unless params[:pr_name].blank?

    @storages = @storages.order("srok asc").paginate(:page => params[:page])

    hobo_index do |format|
      format.html {}
      format.js   { hobo_ajax_response }
  #    format.csv  { send_data Order.to_csv(@goods) }
  #    format.xls  { send_data Order.to_csv(@goods, col_sep: "\t") }
  #    format.xls {}
       format.json { render json: @storages}
    end
  end

  def create
      @storages = Storage.find_by_name(params[:storagenew][:name])
      if @storages && params[:storagenew][:location_good] == 'stor' then
        if @storages.filial_id.to_i == params[:filial_id].to_i then
             @storages.count = (@storages.count.to_f + Good.find(params[:id_good]).count.to_f).to_f
             @storages.cena = (Good.find(params[:id_good]).cena.to_f*(Good.find(params[:id_good]).nacenka.to_f/100)+Good.find(params[:id_good]).cena.to_f)
        else
             @storages = Storage.new(params[:storagenew])
             @storages.count = Good.find(params[:id_good]).count
             @storages.filial_id = params[:filial_id]
             @storages.pr_name = params[:pr_name]
        end
      else
        @storages = Storage.new(params[:storagenew])
        @storages.count = Good.find(params[:id_good]).count
        @storages.filial_id = params[:filial_id]
        @storages.pr_name = params[:pr_name]
      end
      respond_to do |format|
        if @storages.save
          format.html { redirect_to(:back, :notice => 'Goods was created.') }
        else
          format.html { render :action => "new" }
        end
      end
  end

  def update
    @gg = Storage.where(:check => true).order("updated_at desc").first
    if params[:storage][:good_minus] &&  @gg != nil
        @storages = Storage.where(:check => true).order("updated_at desc").first
        @storages.good_minus = params[:storage][:good_minus]
        @storages.save!
     respond_to do |format|
       format.js  { hobo_ajax_response }
       format.html {  redirect_to(storages_url)  }
      end
    else
      hobo_update
    end
  end

  def to_storage
    Storage.to_storage(params[:id])
     respond_to do |format|
       format.js  
       format.html { redirect_to(storages_url) }
      end
  end

  def del_check
    @s = Storage.where(:check => true)
    @s.each{|x| x.check = false
                x.good_minus = 0.0
                    x.save!}
    redirect_to :back
  end

end
