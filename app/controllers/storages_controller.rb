class StoragesController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def index

    # FILTERS
      #Save param to session
      %w(price_name location_good filial_name).each do |key|                                                                                                           
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
    @storages = @storages.where("price_id like ?", params[:price_name]) unless params[:price_name].blank?
    @storages = @storages.paginate(:page => params[:page])

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
      puts params[:storagenew]
      @storages = Storage.find_by_name(params[:storagenew][:name])
      if @storages && params[:storagenew][:location_good] == 'stor' then
        if @storages.filial_id.to_i == params[:filial_id].to_i then
             @storages.count = (@storages.count.to_f + Good.find(params[:id_good]).count.to_f).to_f
        else
             @storages = Storage.new(params[:storagenew])
             @storages.count = Good.find(params[:id_good]).count
             @storages.filial_id = params[:filial_id]
        end
      else
        @storages = Storage.new(params[:storagenew])
        @storages.count = Good.find(params[:id_good]).count
        @storages.filial_id = params[:filial_id]
      end
      respond_to do |format|
        if @storages.save
          format.html { redirect_to(:back, :notice => 'Goods was created.') }
        else
          format.html { render :action => "new" }
        end
      end
  end

  def to_storage
    Storage.to_storage(params[:id])
    redirect_to :back
  end

end
