Rails.application.routes.draw do
  mount ParamsChecker::Engine => "/params_checker"
end
