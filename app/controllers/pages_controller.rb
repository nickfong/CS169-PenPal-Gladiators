class PagesController < ApplicationController
    skip_filter :check_access_token

    def homepage
        render "public/homePage", :formats => :html
    end

    def startpage
        render "public/startPage", :formats => :html
    end

    def landingpage
        render "public/landingPage", :formats => :html
    end
end
