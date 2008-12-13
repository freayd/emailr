module NewslettersHelper
  def var_definitions
    Array.new << [ :date,       'date d\'envoi de l\'email'         ] \
              << [ :time,       'heure d\'envoi de l\'email'        ] \
              << [ :first_name, 'prénom du destinataire'            ] \
              << [ :last_name,  'nom du destinataire'               ] \
              << [ :email,      'email du destinataire'             ] \
              << [ :birth,      'date de naissance du destinataire' ] \
              << [ :age,        'age du destinataire'               ]
  end
end
