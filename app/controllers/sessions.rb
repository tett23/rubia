Rubia::App.controllers :sessions, priority: :high do
  get :sign_in do
    render 'session/sign_in'
  end

  get :login, priority: :high do
    render 'sessions/login'
  end

  get :destroy do
    set_current_account(nil)
    session.clear
    redirect url(:root, :index)
  end
end
