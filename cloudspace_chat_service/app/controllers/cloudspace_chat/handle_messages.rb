class CloudspaceChat::HandleMessages < ApplicationController

  # connect a user and give them permission to post
  def connect
    @current_room_user = CloudspaceChat::CurrentRoomUser.find_by_user_id_and_room_id(current_user.id, params[:room_id])
    if @current_room_user.nil?
      @current_room_user = CloudspaceChat::CurrentRoomUser.create(
        :room_id => params[:room_id], 
        :user_id => current_user.id, 
        :connected => false,
        :allowed => true,
        :banned => false)
    end

    current_room_user_hash = @current_room_user.connect_and_generate_hash
    respond_to do |format|
      if current_room_user_hash
        format.json { render :json => { :user_hash => current_room_user_hash } }
      else
        format.json { render :json => { :error => "A user hash could not be created" } }
      end
    end
  end

  def disconnect
    @current_room_user = CloudspaceChat::CurrentRoomUser.find_by_user_hash(params[:user_hash]) 
    @current_room_user.disconnect_user_and_remove_hash
  end

  # the user validation check on the hash should probably be done in a before filter
  def send_message
    @current_room_user = CloudspaceChat::CurrentRoomUser.find_by_user_hash(params[:user_hash])

    respond_to do |format|
      if @current_room_user.user_id == current_user.id
        @message = CloudspaceChat::Message.new(:current_room_user_id => @current_room_user.id, :input_text => params[:message])
        if(@message.save)
          format.json { render :json => { :message_id => @message.id, :message_text => @message.output_text } }
        else
          format.json { render :json => { :error => "The message could not be saved." } }
        end
      else
        format.json { render :json => { :error => "The user could not be found." } }
      end
    end
  end

  # the user validation check on the hash should probably be done in a before filter
  def get_messages_since_timestamp(timestamp)
    @current_room_user = CloudspaceChat::CurrentRoomUser.find_by_user_hash(params[:user_hash])
    respond_to do |format|
      if @current_room_user.user_id == current_user.id
        if params[:timestamp] == "undefined"
          created_at = 1.year.ago
        else
          created_at = Time.at(params[:timestamp].to_i/1000).localtime
        end

        # this could be written much better
        @messages = CloudspaceChat::Message.created_after(created_at)
        @output_messages = {}
        @messages.each do |message|
          # id is listed twice here becuase I am not sure which one will be more useful
          @output_messages[message.id] = {
            :id => message.id,
            :text => message.output_text,
            :user_name => message.current_room_user.user.name
          }
        end

        format.json { render :json => @output_messages }
      else
        format.json { render :json => { :error => "The user could not be found." } }
      end
    end
  end
end
