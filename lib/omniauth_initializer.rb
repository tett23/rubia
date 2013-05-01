# coding: utf-8

module Rubia
  module OmniauthInitializer
    def self.registered(app)
      app.use OmniAuth::Builder do
        provider :twitter, TwitterKeys.consumer_key, TwitterKeys.consumer_secret
      end
    end
  end
end
