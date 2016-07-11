class WelcomeController < ApplicationController
  def index
    redirect_to '/mailbox/login.html'
  end
end
