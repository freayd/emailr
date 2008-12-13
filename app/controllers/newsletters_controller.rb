class NewslettersController < ApplicationController
  @@sub_menu << { :name => 'Liste',   :path => :newsletters    } \
             << { :name => 'Nouveau', :path => :new_newsletter }


  def index
    @count       = current_customer.newsletters.size
    @newsletters = current_customer.newsletters.find(:all, :order => 'start_at ASC')
  end

  def new
    @newsletter = Newsletter.new(:start_at => Date.today, :frequency => 2, :frequency_unit => 'week')

    @var_definitions = [
      [ :date,       'date d\'envoi de l\'email'         ],
      [ :time,       'heure d\'envoi de l\'email'        ],
      [ :first_name, 'prénom du destinataire'            ],
      [ :last_name,  'nom du destinataire'               ],
      [ :email,      'email du destinataire'             ],
      [ :birth,      'date de naissance du destinataire' ],
      [ :age,        'age du destinataire'               ]
    ]
  end

  def create
    @newsletter = current_customer.newsletter.new(params[:newsletter])
    if @newsletter.save
      flash[:notice] = 'Votre newsletter à bien été enregistrée. Le prochain envoi est programmé.'
      redirect_to(newsletters_path)
    else
      flash[:error] = 'Une erreur est survenue lors de l\'enregistrement de votre newsletter.'
      render :action => 'new'
    end
  end
end
