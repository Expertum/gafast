class GoodsController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def index
    @goods = Good.
      search(params[:search], :id, :codeg, :name, :cena ).
      order_by(parse_sort_param(:id, :name, :codeg))

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
    Good.import(params[:file], params[:price])
    redirect_to :back, notice: "Goods imported."
  end

end
