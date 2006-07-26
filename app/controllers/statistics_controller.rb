class StatisticsController < ApplicationController
  layout 'play' 
	helper :play
	
  def index
    @user = User.find(@session[:user][:id])
    @players = Statistic.players(@user.user_instance.instance_id)
    @buildings = Statistic.buildings(@user.user_instance.instance_id)
    @squares = Statistic.squares(@user.user_instance.instance_id)
    @cash = Statistic.cash(@user.user_instance.id)
    @buyable = Statistic.buyable(@user.user_instance.instance_id)
    @built = Statistic.built(@user.user_instance.instance_id)
    @quickies = Statistic.quickies(@user.user_instance.instance_id)
    @empty = Statistic.empties(@user.user_instance.instance_id)
  end
end
