# coding: utf-8

Rubia::App.controllers :accounts do
  get :index do |screen_name|
    @account = Account.first(screen_name: screen_name.to_sym)

    #render 'accounts/index'
  end
end
