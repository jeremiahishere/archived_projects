class PagesController < ApplicationController
  def index
    if user_signed_in?
      @events = Event.newest_by_creation.limit(3)
    else
      @events = Event.public.newest_by_creation.limit(3)
    end
  end

  def your_events
  end
end
