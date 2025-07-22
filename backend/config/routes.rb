Rails.application.routes.draw do

  # google-oauth
  get '/auth/:provider/callback', to: 'sessioins#google_auth'
  get '/auth/failure', to: redirect('http://127.0.0.1:5173/login')

  namespace :api do
    namespace :v1 do
      # users
      post 'create_user/', to: 'users#create_user'
      patch 'update_user/:id/', to: 'users#update_user'

      # user_login
      post 'user_login/', to: 'users#user_login'

      # refresh_token
      get 'refresh_token/', to: 'users#refresh_token'

      # send_reset_email
      post 'send_reset_email/', to: 'users#send_reset_email'

      # reset_email
      post 'reset_email/', to: 'users#reset_email'

      # students
      post 'create_student/', to: 'students#create_student'
      get 'single_student/:id/', to: 'students#single_student'
      get 'all_students/', to: 'students#all_students'
      patch 'update_student/:id/', to: 'students#update_student'
      delete 'delete_student/:id/', to: 'students#delete_student'

      # courses
      post 'create_course/', to: 'courses#create_course'
      get 'all_courses/', to: 'courses#all_courses'
      get 'single_course/:id/', to: 'courses#single_course'
      patch 'update_course/:id/', to: 'courses#update_course'
      delete 'delete_course/:id/', to: 'courses#delete_course'
    end
  end
end
