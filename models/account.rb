class Account
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :email, String
  property :role, String
  property :screen_name, String, :unique=>true
  property :uid, String
  property :provider, String
  property :updated_at, DateTime
  property :created_at, DateTime

  def self.create_with_omniauth(auth)
    account = first_or_create({
      :uid => auth['uid'],
      :provider => auth['provider'],
      :name => auth['info']['name'],
      :screen_name => auth['info']['nickname'],
      :role => :users
    })

    account
  end

  # omniauthがARを前提にしている
  def self.find_by_id(id)
    get(id)
  end

  def self.detail(screen_name)
    first(screen_name: screen_name)
  end
end
