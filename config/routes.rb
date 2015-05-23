Rails.application.routes.draw do
  
  get 'devocionales' => 'main#all_days', :as => 'all_days'
  get 'devocional_de_hoy(/:id)' => 'main#today', :as => 'today'
  get 'descargar_devocional/:id' => 'main#download_devotional', :as => 'download_devotional'

  devise_for :users
  
  resources :devotionals, :except => [:show]

  root 'main#all_days'

end
