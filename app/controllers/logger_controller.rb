class LoggerController < ApplicationController
  include Tracking

  def email_opened
    @subscriber = Subscriber.find(params[:s])
    @issue      = Issue.find(params[:i])

    @visitor = visitor_by_param
    EmailingLog.create(:visitor => @visitor, :issue => @issue)

    response.content_type = 'image/gif'
    render :text => empty_gif_content
  end

  # Redirect to about:blank unless params[:u].
  def email_forward
    @subscriber = Subscriber.find(params[:s])
    @issue      = Issue.find(params[:i])
    @url        = params[:u]

    @visitor = visitor_by_param
    EmailingLinkLog.create(:visitor => @visitor, :issue => @issue, :forward_to => @url)

    redirect_to @url
  end

  def tracking
    @customer = Customer.find(params[:c])
    # TODO Log visitor.

    response.content_type = 'image/gif'
    render :text => empty_gif_content
  end

  protected

    def empty_gif_content
      ActiveSupport::Base64.decode64('R0lGODlhAQABAJEAAAAAAP///////wAAACH5BAEAAAIALAAAAAABAAEAAAICVAEAOw==').freeze
    end

    def visitor_by_param
      @visitor   = Visitor.find_by_subscriber_id(@subscriber)
      @visitor ||= Visitor.new(:customer => @subscriber.customer, :subscriber => @subscriber)

      @visitor.new_cookie! unless @visitor.cookie?

      update_visitor_attributes(@visitor)

      @visitor.save
      @visitor
    end

    def update_visitor_attributes(visitor)
      # TODO Add visitor infos.
    end

end
