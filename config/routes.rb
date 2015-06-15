Rails.application.routes.draw do
  resource :receive, only: [] do
    collection do
      post :tweet
    end
  end
end