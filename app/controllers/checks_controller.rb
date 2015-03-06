class ChecksController < ApplicationController

  hobo_model_controller

  auto_actions :all


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
