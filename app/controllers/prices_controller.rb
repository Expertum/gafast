# coding: utf-8
class PricesController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def index

    # FILTERS
      #Save param to session
      %w(enddate startdate).each do |key|                                                                                                           
         if not params[key].nil?; session[key] = params[key]
           elsif not session[key].nil?; params[key] = session[key]
           end
         params.delete(key) if params[key].blank?
     end
      #---
    @prices = Price.
      search(params[:search], :id, :name).
      includes(:filial).
      order_by(parse_sort_param(:filial => "filials.name",
                               :poster => 'users.name'))


    params[:enddate]   = Date.today.to_s                if params[:enddate].  blank? and !params[:startdate].blank?
    params[:startdate] = Date.parse('2013-01-01').to_s  if params[:startdate].blank? and !params[:enddate].  blank?
    if !params[:startdate].blank? and !params[:enddate].blank? then
         @prices = @prices.where("#{@s} between ? and ?", Date.parse(params[:startdate]) ,Date.parse(params[:enddate]))
    end

    if !params[:enddate].blank? || !params[:startdate].blank?
       @o_count = @prices.count
    else
       @o_count = 30
    end

   # @orders = @orders.callcentr if  current_user.callcenter?

    @prices = @prices.paginate(:page => params[:page], :per_page => @o_count)

  hobo_index do |format|
    format.html {}
    format.js   { hobo_ajax_response }
    format.json { render json: @prices }
  end

 end

  def show
    @logs = Price.find(params[:id]).logs.paginate(:page => params[:page])
    hobo_show
  end

end
