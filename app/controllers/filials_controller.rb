# coding: utf-8
class FilialsController < ApplicationController

  hobo_model_controller

  auto_actions :all

 def index
    @filials = Filial.
      search(params[:search], :id, :name, :contact_name).
      includes(:prices).
      order_by(parse_sort_param(:name, :contact_name))

    # FILTERS
    params[:enddate]   = Date.today.to_s                if params[:enddate].  blank? and !params[:startdate].blank?
    params[:startdate] = Date.parse('2013-01-01').to_s  if params[:startdate].blank? and !params[:enddate].  blank?
    if !params[:startdate].blank? and !params[:enddate].blank? then
      #@filials = @filials.include(:orders).where('orders.crash_date', Date.parse(params[:startdate])..Date.parse(params[:enddate]))
      @filials = @filials.where('prices.created_at >= :start_date AND prices.created_at <= :end_date', {start_date: params[:startdate], end_date: params[:enddate] })
    end

  @filials = @filials.paginate(:page => params[:page])

  hobo_index do |format|
    format.html
    format.js   { hobo_ajax_response }
    format.json { render json: @filials }
  end

 end


end
