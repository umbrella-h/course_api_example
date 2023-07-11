Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'homepages#index'

  namespace :api do
    namespace :v1 do
      resources :users do
        resources :courses, controller: 'user_courses', only: %i[index]
        resources :enrollments, controller: 'user_enrollments', only: %i[index]
      end

      resources :courses, only: %i[show] do
        resources :users, controller: 'course_users', only: %i[index]
        resources :enrollments, controller: 'course_enrollments', only: %i[index]
      end

      resources :enrollments, only: %i[create destroy show]
    end
  end
end
