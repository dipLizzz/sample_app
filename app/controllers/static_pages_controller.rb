class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    else
      @micropost = Micropost.new # Initialize a new micropost if user is not logged in
      @feed_items = [] # Initialize an empty array if no user is logged in
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
