class WebsitesController < ApplicationController

  before_filter :get_website_by_id, :only => [:show, :edit, :update, :destroy, :crawl, :search]

  def get_website_by_id
    @website = Website.find(params[:id])
  end 

  def index
    @websites = Website.all
  end 

  def show
  end 

  def new 
    @website = Website.new
  end 

  def edit
  end 

  def crawl
    @website.crawl_website
    redirect_to(websites_path, :notice => "Website was successfully crawled.")
  end

  def search
    results = @website.search(params[:search_string])
    @search_results = Array.new
    results[0].each_pair do |page_id, count|
      page = WebsitePage.find_by_id(page_id)
      @search_results.push({"url" => page.url, "name" => page.name, "count" => count})
    end
    @words_not_found = results[1]
  end

  def create
    @website = Website.new(params[:website])
    if @website.save
      redirect_to(website_path(@website), :notice => "Website was successfully created.")
    else
      render(:action => "new")
    end 
  end 

  def update
    if @website.update_attributes(params[:website])
      redirect_to(website_path(@website), :notice => "Website was successfully updated.")
    else
      render( :action => "edit" )
    end 
  end 

  def destroy
    @website.destroy
    redirect_to(websites_url, :notice => "Website was successfully deleted.")
  end 
end 
