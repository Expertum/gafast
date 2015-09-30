# coding: utf-8
class NewsController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def index
    @news = News.
      search(params[:search], :id, :title).
      order_by(parse_sort_param(:id, :title))

     respond_to do |format|
      @news.each do |one|
       unless one.read_by?(current_user)
         format.js  { render :js => "find_read();" } 
         format.html {}
       else
         format.js  { hobo_ajax_response }
         format.html {}
       end
      end
     end
  end

  def show
    puts '*************************************'
    find_instance.mark_read_by(current_user)
    puts 'зробили як прочитане'
    hobo_show do
      this.attributes = params[:order] || {}
      hobo_ajax_response if request.xhr?
    end
  end
 
end
