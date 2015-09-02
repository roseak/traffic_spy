class Registration # < ActiveRecord::Base

  def initialize(params)
    @identifier = params[:identifier]
    @root_url = params[:rootUrl]
  end

end
