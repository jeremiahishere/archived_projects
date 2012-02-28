class GamesController < ApplicationController
  load_and_authorize_resource

  before_filter :check_show_permission, :only => [ :show, :interact ]
  before_filter :check_edit_permission, :only => [ :edit ]
  before_filter :check_full_permission, :only => [ :destroy ]

  def check_show_permission
    @game = Game.find(params[:id])
    if !@game.has_permission?(current_user, "show")
      redirect_to games_path, :notice => "You do not have enough permissions to view this page"
    end
  end

  def check_edit_permission
    @game = Game.find(params[:id])
    if !@game.has_permission?(current_user, "edit")
      redirect_to games_path, :notice => "You do not have enough permissions to view this page"
    end
  end

  def check_full_permission
    @game = Game.find(params[:id])
    if !@game.has_permission?(current_user, "full")
      redirect_to games_path, :notice => "You do not have enough permissions to view this page"
    end
  end

  def index
    if current_user.has_role?(:admin)
      @games = Game.all
    else
      @games = Game.by_permissions(current_user)
    end

    respond_to do |format|
      format.html
    end
  end

  def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def new
    @game = Game.new

    respond_to do |format|
      format.html
    end
  end

  def edit 
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html
    end
  end
  
  def create
    @game = Game.new(params[:game])
    @game.user = current_user
    @game.in_progress = true

    respond_to do |format|
      if @game.save
        format.html { redirect_to(@game, :notice => "Created a game") }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to(@game, :notice => "Updated a game") }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to(games_url) }
    end
  end
end
