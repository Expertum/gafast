# coding: utf-8
class StoragesController < ApplicationController

  hobo_model_controller

  auto_actions :all
  respond_to :js, :html

  def index
        @c_summ  = 0
        @k_summ = 0
        @i = 0
        @asum = 0
        @d = 0
        @ii = 0
        @dd = 0
        @ci = 0
        @cd = 0
    # FILTERS
      #Save param to session
      %w(location_good filial_name pr_name).each do |key|                                                                                                           
         if not params[key].nil?; session[key] = params[key]
           elsif not session[key].nil?; params[key] = session[key]
           end
         params.delete(key) if params[key].blank?
     end
      #---

    if params[:location_good].blank? then params[:location_good] = 'stor' end
    if params[:filial_name].blank? then params[:filial_name] = current_user.filial.id.to_i end
 
    @storages = Storage.
      search(params[:search], :id, :codeg, :name, :cena, :morion).
      order_by(parse_sort_param(:id, :name, :codeg, :cena, :count))

    @storages = @storages.where("filial_id like ?", params[:filial_name]) unless params[:filial_name].blank?
    @storages = @storages.where("location_good like ?", params[:location_good]) unless params[:location_good].blank?

    @storages = @storages.where("pr_name like ?", params[:pr_name]) unless params[:pr_name].blank?

    @storages.each{|s| if s.count == 0 then s.location_good = 'defect' end; s.save!}

    @storages = @storages.order("srok asc").paginate(:page => params[:page]) if params[:location_good] != 'defect'

    hobo_index do |format|
      format.html {}
      format.js   { hobo_ajax_response }
  #    format.csv  { send_data Order.to_csv(@goods) }
       format.xls  { 
         storages = Spreadsheet::Workbook.new
         list = storages.create_worksheet :name => 'заказ'
         list.row(0).concat %w{Код_товара Товар	Производитель Срок_годности Предоплата Признак_НДС Количество} 
         @storages.each_with_index { |storage, i|
              @cena_p = (storage.cena.to_f/(1+(storage.nds.to_f+35)/100)).round(2)
              if storage.pr_name == 'Оптима' || storage.pr_name == 'Вента' then 
                 @dd = storage.codeg.to_i.to_s
              else
                 @dd = storage.codeg.to_s
              end
              list.row(i+1).push @dd, storage.name, storage.madein, storage.srok, @cena_p.to_s, storage.nds.to_i.to_s, storage.count

         }
        header_format = Spreadsheet::Format.new ({ :weight => :bold, :pattern => 1, :pattern_fg_color => :silver})
        list.row(0).default_format = header_format
        #output to blob object
        blob = StringIO.new()
        storages.write blob
        #respond with blob object as a file
        send_data blob.string, :type => :xls, :filename => 'order_list.xls';
       }
  #    format.xls {}
       format.json { render json: @storages}
    end
  end

  def create
#      @storages = Storage.find_by_name(params[:storagenew][:name])
      @s_name = params[:storagenew][:name]
      @s_madein = params[:storagenew][:madein]
      @s_price = params[:pr_name]
      
      @storages = Storage.where(:name => @s_name, :pr_name => @s_price, :madein => @s_madein).first
      if (@storages != nil) && params[:storagenew][:location_good] == 'stor' then
        if @storages.filial_id.to_i == params[:filial_id].to_i then
#             puts "Мі тут ***********************************"
             @storages.count = (@storages.count.to_f + Good.find(params[:id_good]).count.to_f).to_f
             @storages.cena = params[:storagenew][:cena].to_f
             @storages.srok = Good.find(params[:id_good]).srok
             @storages.location_good = params[:storagenew][:location_good]
        else
#             puts "Мі тут ***********************************"
             @storages = Storage.new(params[:storagenew])
             @storages.count = Good.find(params[:id_good]).count
             @storages.filial_id = params[:filial_id]
             @storages.pr_name = params[:pr_name]
        end
      else
#             puts "Мі тут ***********************************"
        @storages = Storage.new(params[:storagenew])
        @storages.count = Good.find(params[:id_good]).count
        @storages.filial_id = params[:filial_id]
        @storages.pr_name = params[:pr_name]
      end
      @g1 = Good.find_by_id(params[:id_good])

      @storages.poster_id = params[:poster_id]
      @storages.to_order = @g1.to_order

      @g1.to_order = 'false'
      @g1.save!       

      respond_to do |format|
        if @storages.save
          format.html { redirect_to(:back, :notice => 'Storage was created.') }
        else
          format.html { render :action => "new" }
        end
      end
  end

  def to_storage
    Storage.to_storage(params[:id])
     respond_to do |format|
       format.js  
       format.html { redirect_to(storages_url) }
      end
  end

  def to_del
    Storage.to_del(params[:id])
     respond_to do |format|
       format.js  { redirect_to(storages_url) }
       format.html { redirect_to(storages_url) }
      end
  end

  def del_check
    if params[:nocheck] then
      @s = Storage.find(params[:nocheck].to_i)
      @s.check = false
      @s.poster_id = nil
      @s.good_minus = 0.0
      @s.save!   
     render :action => "index"
    else
      @s = Storage.where(:check => true, :filial_id => params[:filial_id], :poster_id => params[:poster_id])
      @s.each{|x| x.check = false
                  x.poster_id = nil
                  x.good_minus = 0.0
                  x.save!}
      redirect_to(storages_url)
    end
  end

  def perenac
    Storage.pernac
    redirect_to(storages_url)
  end

  def chcodeg
      Storage.all.each{|x| if x.w_codeg?
                              d = x.w_codeg?[1]
                              if x.pr_name.include?('Оптима') || x.pr_name.include?('Вента')
                                 x.codeg = d[0..-3]
                              else
                                 x.codeg = d
                              end
                              x.save!
                           end}
    redirect_to(storages_url)
  end

  def addposter
    if params[:add_poster_id] then
       @s = Storage.find(params[:storage_id].to_i)
       @s.poster_id = params[:add_poster_id]
       puts ''
       puts "Додали постера після натискання галочкі"
       puts "***************************************"
       puts User.find(@s.poster_id.to_i)
       puts "***************************************"
       @s.save!
    end
    render :action => "index"
  end

  def add_minus
    if params[:add_minus] == 'add_minus'
       @s = Storage.find(params[:stor_id].to_i)
       @s.good_minus = params[:storage][:good_minus]
       puts ''
       puts "Додали кількість товару яку необхідно продати"
       puts "***************************************"
       puts @s.good_minus
       puts "***************************************"
       @s.save!
       @s.save!
    end
    render :action => "index"
  end

end
