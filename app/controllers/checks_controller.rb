class ChecksController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def index
      @ss = 0
      @sm = 0
      @sum = 0
      @ii = 0
      @dd1 = []
    # FILTERS
      #Save param to session
      %w(filial_name date_order startdate enddate).each do |key|                                                                                                           
         if not params[key].nil?; session[key] = params[key]
           elsif not session[key].nil?; params[key] = session[key]
           end
         params.delete(key) if params[key].blank?
     end
      #---

    @checks = Check.
      search(params[:search], :check_text, :id).
      order_by(parse_sort_param(:id, :check_text))

    params[:enddate]   = Date.today.to_s                if params[:enddate].  blank? and !params[:startdate].blank?
    params[:startdate] = Date.parse('2015-01-01').to_s  if params[:startdate].blank? and !params[:enddate].  blank?
    @s = params[:date_order]
    if !params[:startdate].blank? and !params[:enddate].blank? then
         @checks = @checks.where("#{@s} between ? and ?", Date.parse(params[:startdate]) ,Date.parse(params[:enddate]))
    end

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
        @s.each{|x| d << x.name.to_s+';'+x.good_minus.to_s+';'+(x.cena.to_f*x.good_minus.to_f).to_s}
        @ct = d.join('||')
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
