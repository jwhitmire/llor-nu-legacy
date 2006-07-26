class FeedController < ApplicationController
	before_filter :login_required, :except => [:rss]
	def rss
		@user = User.find(params[:id])
		@activity = Payment.recent_activity(@user)
		render :action => "rss", :layout => false
	end
end