Rails.application.routes.draw do
  namespace :api do
    scope module: :v1 do
      post '/authenticate', to: 'authentication#authenticate'
      resources :articles, except: [:new, :edit]

      post '/articles/:id/add_to_favorites', to: 'articles#add_to_favorites'
      get '/favorites', to: 'articles#show_favorites'
      get '/show_authors', to: 'articles#show_authors'
      get '/author/:id', to: 'articles#show_author_articles'
      get '/show_unread_articles', to: 'articles#show_unread_articles'
    end
  end
end
