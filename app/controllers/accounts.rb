# coding: utf-8

Rubia::App.controllers :accounts, map: '/' do
  before do
    @page_header = :accounts
    @account = Account.detail(params[:screen_name])
    #add_breadcrumbs(@account.name, url(:accounts, :index, screen_name: @account.screen_name))
  end

  get :index, map: '/:screen_name', priority: :low do |screen_name|
    @account = Account.first(screen_name: screen_name.to_sym)

    render 'accounts/index'
  end
end
