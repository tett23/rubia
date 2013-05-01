# coding: utf-8

Rubia::App.controllers :accounts do
  get :show, map: '/accounts/:screen_name' do |screen_name|
    @account = Account.first(screen_name: screen_name.to_sym)
    exist_or_404(@account)

    @works = Work.list(current_account.id)
    add_breadcrumbs(screen_name, url(:accounts, :show, screen_name: screen_name))

    render 'accounts/show'
  end
end
