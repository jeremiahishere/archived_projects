class WebsitePagesController < ApplicationController
  before_filter :get_website_page_by_id, :only => [:show, :edit, :update, :destroy]

  def get_website_page_by_id
    @website_page = WebsitePage.find(params[:id])
  end 

  def index
    @website_pages = WebsitePage.all
  end 

  def show
  end 

  def new 
    @website_page = WebsitePage.new
  end 

  def edit
  end 

  def create
    @website_page = WebsitePage.new(params[:website_page])
    if @website_page.save
      redirect_to(website_page_path(@website_page), :notice => "Website Page was successfully created.")
    else
      render(:action => "new")
    end 
  end 

  def update
    if @website_page.update_attributes(params[:website_page])
      redirect_to(website_page_path(@website_page), :notice => "Website Page was successfully updated.")
    else
      render( :action => "edit" )
    end 
  end 

  def destroy
    @website_page.destroy
    redirect_to(website_pages_url, :notice => "Website Page was successfully deleted.")
  end 
end 
