Upis::Application.routes.draw do
  resources :gwas, :only => [:index, :create]

  resources :sections do
    member do
      put 'enroll_to_section'
      get 'unenroll/:student_id' =>  'sections#unenroll_student'
    end
  end
  resources :faculties do
    get 'regenerate_password', :on => :member
    get 'toggle_activity', :on => :member
  end

  resources :schoolyears do
      get 'make_current', :on => :member
  end

  resources :courses do
    put 'enroll_students', :on => :member
    get 'unenroll/:student_id' =>  'courses#unenroll_student'
    get 'grading_sheet', :on => :member
    put 'update_grades', :on => :member
    get 'unenroll_students' => 'courses#unenroll_students'
  end

  get 'my_classes' => 'courses#my_classes'
  get 'request_unlock/:id' => 'courses#request_unlock'
  get 'process_request/:id/:decision' => 'courses#process_request'

  match 'sections/year/:schoolyear_id' => 'sections#year'
  match 'sections/new/:schoolyear_id' => 'sections#new'
  match 'sections/for_sectionid/:id' => 'sections#for_sectionid'

  match 'courses/new/:schoolyear_id/' => 'courses#new'
  match 'courses/removal/:id/:student_id/:verdict' => 'courses#removal'

  match 'grades/deficiency/:quarter/' => 'grades#deficiency'
  match 'grades/quarter-report/:type/:id/:orientation' => 'grades#quarterreport'
  match 'grades/transcript/:student_id/' => 'grades#transcript'

  get 'students/new/:batch_id' => 'students#new'
  match 'students/transcript/:student_id' => 'students#transcript'
  match 'students/transcript_builder/:student_id' => 'students#transcript_builder'
  match 'students/honorroll/:student_id' => 'students#honorroll'
  match 'students/classcard/:student_id' => 'students#classcard'
  match 'students/get_students_list/:id' =>'students#get_students_list'

  match 'settings' => 'settings#edit'
  post 'settings/update' => 'settings#update'

  get 'gwas/range' => 'gwas#range'

  resources :subjects

  resources :departments

  resources :students, :except => [:index]

  resources :batches

  devise_for :users do
    root :to => "home#index"
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

