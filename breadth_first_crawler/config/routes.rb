BreadthFirstCrawler::Application.routes.draw do
  root :to => "websites#index"
  resources :websites
  match "websites/:id/crawl", :to => "websites#crawl", :as => "crawl_website"
  match "websites/:id/search", :to => "websites#search", :as => "search_website"
  resources :website_pages
end
