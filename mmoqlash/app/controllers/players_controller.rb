class PlayersController < ApplicationController
  before_action :set_player, only: [:show, :edit, :update, :destroy]

  # GET /players
  # GET /players.json
  def index
    @players = Player.all
  end

  # GET /players/1
  # GET /players/1.json
  def show
  end

  # GET /players/new
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
    @player = Player.find(params[:id])
    room = Room.find(@player.room_id) rescue Room.new

    @player.room_id = room.code
  end

  # POST /players
  # POST /players.json
  def create
    room_code = params[:player][:room_id]
    room = Room.find_by_code(room_code)

    potential_existing_players = Player.where(:alias => params[:player][:alias], :room_id => room.id)
    
    if potential_existing_players.count > 0
      @player = potential_existing_players.first
    else
      @player = Player.new(player_params.merge(room_id: room.id))
    end

    respond_to do |format|
      if @player.save
        format.html { redirect_to "/play/#{room.id}/#{@player.id}", notice: 'Player was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
  def update
    room_code = params[:player][:room_id]
    room = Room.find_by_code(room_code)

    respond_to do |format|
      if @player.update(player_params.merge(room_id: room.id))
        format.html { redirect_to "/play/#{room.id}/#{@player.id}", notice: 'Player was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.json
  def destroy
    @player.destroy
    respond_to do |format|
      format.html { redirect_to players_url, notice: 'Player was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.require(:player).permit(:alias, :room_id)
    end
end
