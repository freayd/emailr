class TrackingController < ApplicationController
  @@sub_menu << { :name => 'Tracker',                   :path => :tracking          } \
             << { :name => 'Log d\'emailing',           :path => :emailing_log      } \
             << { :name => 'Log des liens d\'emailing', :path => :emailing_link_log } \
             << { :name => 'Log de tracking',           :path => :tracking_log      }


  def index
  end

  def emailing_log
    @logs = paginated_logs(EmailingLog)
  end

  def emailing_link_log
    @logs = paginated_logs(EmailingLinkLog)
  end

  def tracking_log
    @logs = paginated_logs(TrackingLog)
  end

  protected
    def paginated_logs(log_class)
      visitor_ids = current_customer.visitor_ids
      log_class.paginate(:page => params[:page], :include => :visitor,
                         :conditions => { :visitor_id => visitor_ids }, :order => 'created_at DESC')
    end
end
