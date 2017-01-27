module Esplanade
  class Railtie < Rails::Railtie
    initializer 'esplanade.insert_middleware' do |app|
      app.config.middleware.use Esplanade::Middleware
    end
  end
end
