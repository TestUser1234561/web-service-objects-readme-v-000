class SearchesController < ApplicationController

  def search
  end

  def friends
    resp = Faraday.get("https://api.foursquare.com/v2/users/self/friends") do |req|
      req.params['oauth_token'] = session[:token]
      # don't forget that pesky v param for versioning
      req.params['v'] = '20160201'
    end
    @friends = JSON.parse(resp.body)["response"]["friends"]["items"]
  end

  def create
    foursquare = FoursquareService.new
    session[:token] = foursquare.authenticate!(ENV['FOURSQUARE_CLIENT_ID'], ENV['FOURSQUARE_SECRET'], params[:code])
    redirect_to root_path
  end
end
