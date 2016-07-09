# coding: utf-8
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

        if !params[:enddate].blank? || !params[:startdate].blank? 
          # puts '**************************************'
           @o_count = @checks.count
        else
          @o_count = 30
         #  puts '-----------------------------------------------------------'
        end

    @checks_for_stat = @checks.paginate(:page => params[:page], :per_page => @o_count)

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

        if params[:poster_id].blank? then 

          @checks = Check.new(params[:check])
      
        else
          @ch_nil =true
          @checks = Check.new

          @checks.poster_id = params[:poster_id]

          if params[:filial_id].nil? then
             @checks.filial_id = User.find(params[:poster_id]).filial_id
          else
             @checks.filial_id = params[:filial_id]
          end
          @s = Storage.where(:check => true, :filial_id => @checks.filial_id, :poster_id => params[:poster_id])
          puts ''
          puts "Формування товару у Чеці:"
          puts "*************************"
          i = 0
          @s.each{|s| puts i+=1
                      puts 'Назва препарату - '+s.name.to_s
                      puts 'Кількість проданого - '+s.good_minus.to_s
                      puts 'Ціна за 1 шт - '+s.cena.to_f.to_s
                      puts 'Ціна проданого -'+(s.cena.to_f*s.good_minus.to_f).to_s;}

            @s.each{|x| d.push(x.name.to_s+';'+x.good_minus.to_s+';'+(x.cena.to_f*x.good_minus.to_f).to_s);x.check = false;x.save!;
                        if x.good_minus.to_i == 0 then @ch_nil = false end
                    }
            @checks.check_text = d.join('||')

            if @ch_nil == true then 
              @s.each{|x|
                          x.check = false;
                          x.count -= x.good_minus;
                          x.good_minus = 0.0;
                          x.poster_id =nil;
                          x.save! 
                      }
            end
#        @s.each{|x| x.check = false
#                    x.count -= x.good_minus
#                    x.good_minus = 0.0
#                    x.save!}
      end

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
