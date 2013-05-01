Rubia::App.controllers :auth do
  get :auth, :map=>'/auth/:provider/callback' do
    auth    = request.env["omniauth.auth"]
    account = Account.create_with_omniauth(auth)
    set_current_account(account)
    session[:account_id] = account.id
    redirect "http://" + request.env["HTTP_HOST"] + url(:root, :index)
  end
end
