class GameTokensController < ApplicationController
  load_and_authorize_resource

  def generate_show_token
    @token = GameToken.create(
      :game_id => params[:game_id],
      :permission_level => "show")

    respond_to do |format|
      format.json { render :json => { :url => process_access_token_url(@token.token) } }
    end
  end
  
  def generate_edit_token
    @token = GameToken.create(
      :game_id => params[:game_id],
      :permission_level => "edit")

    respond_to do |format|
      format.json { render :json => { :url => process_access_token_url(@token.token) } }
    end
  end

  def process_token
    @token = GameToken.find_by_token(params[:token])
    unless @token.expired?
      perm = GamePermission.find_or_create_by_user_id_and_game_id(current_user.id, @token.game.id)
      perm.permission_level = @token.permission_level
      perm.save
    end

    respond_to do |format|
      format.html { redirect_to(interact_game_path(@token.game), :notice => "You have been added to this game.") }
    end
  end
end
