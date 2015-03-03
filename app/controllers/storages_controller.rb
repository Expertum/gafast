class StoragesController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def index

    @storages = Storage.
      search(params[:search], :id, :codeg, :name, :cena ).
      order_by(parse_sort_param(:id, :name, :codeg))

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
      @storages = Storage.find_by_name(params[:storagenew][:name])
      if @storages then
        if @storages.filial_id.to_i == params[:filial_id].to_i then
             @storages.count = (@storages.count.to_i + Good.find(params[:id_good]).count.to_i).to_s
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

end
