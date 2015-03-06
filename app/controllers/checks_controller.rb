class ChecksController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def index

    # FILTERS
      #Save param to session
      %w(filial_name).each do |key|                                                                                                           
         if not params[key].nil?; session[key] = params[key]
           elsif not session[key].nil?; params[key] = session[key]
           end
         params.delete(key) if params[key].blank?
     end
      #---

    @checks = Check.
      search(params[:search], :check_text, :id).
      order_by(parse_sort_param(:id, :check_text))

    @checks = @checks.where("filial_id like ?", params[:filial_name]) unless params[:filial_name].blank?

    @checks = @checks.paginate(:page => params[:page])

    hobo_index do |format|
      format.html {}
      format.js   { hobo_ajax_response }
  #    format.csv  { send_data Order.to_csv(@goods) }
  #    format.xls  { send_data Order.to_csv(@goods, col_sep: "\t") }
  #    format.xls {}
       format.json { render json: @checks}
    end
  end

  def create
        d =[]
        @checks = Check.new
        @checks.filial_id = params[:filial_id]
        @checks.poster_id = params[:poster_id]
        @s = Storage.where(:check => true)
        @s.each{|x| d << x.name.to_s+';'+x.count.to_s}
        @ct = d.join('/')
        @checks.check_text = @ct

        @s.each{|x| x.check = false
                    x.count -= x.good_minus
                    x.good_minus = 0.0
                    x.save!}
      respond_to do |format|
        if @checks.save
          format.html { 
                        render :action => "show"  }
        else
          format.html { render :action => "new" }
        end
      end
  end

end
