require 'browser'

class RootController < ApplicationController
    def index
        user_agent = request.user_agent
        browser = Browser.new(user_agent)
        tablet = browser.device.tablet? ? 'tablet' : nil
        mobile = browser.device.mobile? ? 'phone' : nil
        desktop = (!browser.device.tablet? && !browser.device.mobile?) ? 'desktop' : nil
        platform = tablet || mobile || desktop
        render :file => "frontend/build/#{platform}.html"
    end
end