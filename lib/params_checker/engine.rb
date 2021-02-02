module ParamsChecker
  class Engine < ::Rails::Engine
    isolate_namespace ParamsChecker

    config.generators do |g|
      g.test_framework :rspec
    end
  end
  class NotEngine
  end
end
