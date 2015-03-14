class GoodsController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def index
        @c_summ  = 0
        @k_summ = 0
        @i = 0
        @asum = 0
    # FILTERS
      #Save param to session
      %w(filial_name).each do |key|                                                                                                           
         if not params[key].nil?; session[key] = params[key]
           elsif not session[key].nil?; params[key] = session[key]
           end
         params.delete(key) if params[key].blank?
     end
      #---

    @goods = Good.
      search(params[:search], :id, :codeg, :name, :cena ).
      order_by(parse_sort_param(:id, :name, :codeg))

    @goods = @goods.where("price_id like ?", params[:price_name]) unless params[:price_name].blank?

    @goods = @goods.paginate(:page => params[:page])

    hobo_index do |format|
      format.html {}
      format.js   { hobo_ajax_response }
  #    format.csv  { send_data Order.to_csv(@goods) }
  #    format.xls  { send_data Order.to_csv(@goods, col_sep: "\t") }
  #    format.xls {}
       format.json { render json: @goods}
    end
  end

  def import
    Good.import(params[:file], params[:price], params[:poster], params[:filid])
    redirect_to :back, notice: "Goods imported."
  end

end
