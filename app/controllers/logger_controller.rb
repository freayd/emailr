class LoggerController < ApplicationController
  include Tracking

  skip_before_filter :login_required

  def email_opened
    load_cookies
    @subscriber = Subscriber.find(params[:s]) rescue nil
    @issue      = Issue.find(params[:i])      rescue nil
    @customer   = @subscriber.customer

    @visitor = visitor_by_param
    EmailingLog.create(:visitor => @visitor, :issue => @issue)
    update_cookies
    @visitor.save

    render_empty_gif
  end

  def email_forward
    begin
      load_cookies
      @subscriber = Subscriber.find(params[:s]) rescue nil
      @issue      = Issue.find(params[:i])      rescue nil
      @customer   = @subscriber.customer
      @url        = params[:u] || 'about:blank' # FIXME 'about:blank' will not work.

      @visitor = visitor_by_param
      EmailingLinkLog.create(:visitor => @visitor, :issue => @issue, :forward_to => @url)
      EmailingLog.create(:visitor => @visitor, :issue => @issue) unless EmailingLog.exists?(:visitor_id => @visitor)
      update_cookies
      @visitor.save

      redirect_to @url
    rescue
      if @customer
        redirect_to @customer.website
      else
        render :text => ''
      end
    end
  end

  def tracking
    load_cookies
    @customer = Customer.find(params[:c]) rescue nil
    @visitor ||= Visitor.new
    @visitor.customer = @customer unless @visitor.customer_id?
    update_visitor_attributes

    TrackingLog.create(:visitor => @visitor) do |tracking_log|
      tracking_log.issue     = @issue if @issue
      tracking_log.url       = params[:u]
      tracking_log.referrer  = params[:r]
      tracking_log.logged_at = Time.parse(params[:t]) if params[:t]
    end

    update_cookies
    @visitor.save

    render_empty_gif
  end

  protected

    def render_empty_gif
      response.content_type = 'image/gif'
      render :text => ActiveSupport::Base64.decode64('R0lGODlhAQABAJEAAAAAAP///////wAAACH5BAEAAAIALAAAAAABAAEAAAICVAEAOw==')
    end

    def visitor_by_param
      @visitor ||= Visitor.find_by_subscriber_id(@subscriber)
      @visitor ||= Visitor.new
      @visitor.subscriber = @subscriber unless @visitor.subscriber_id?
      @visitor.customer   = @customer   unless @visitor.customer_id?

      update_visitor_attributes
      @visitor
    end

    def update_visitor_attributes
      @visitor.ip_address    = request.remote_ip
      @visitor.user_agent    = request.env['HTTP_USER_AGENT']
      @visitor.screen_width  = params[:sw]
      @visitor.screen_height = params[:sh]
      @visitor.pixel_depth   = params[:sp]
      @visitor.color_depth   = params[:sc]
    end

    TRACK_KEY = :emr_track
    ISSUE_KEY = :emr_issue

    def load_cookies
      @visitor ||= Visitor.find_by_cookie(cookies[TRACK_KEY]) rescue nil
      @issue   ||= Issue.find(cookies[ISSUE_KEY])             rescue nil
    end
    def update_cookies
      @visitor.new_cookie! unless @visitor.cookie?
      cookies[TRACK_KEY] = { :value => @visitor.cookie.to_s, :expires => 1.month.from_now   }
      cookies[ISSUE_KEY] = { :value => @issue.id.to_s,       :expires => 5.minutes.from_now } if @issue
    end
end
