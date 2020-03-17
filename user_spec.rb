require_relative 'runner'

require 'sequel'

Sequel.connect 'postgres://localhost/tests'

class User < Sequel::Model(:users)
  def change_email(email)
    update(email: email)
  end
end

describe User do
  def user
    @user ||= User.create(email: 'alice@example.com',
      last_login: Time.new(2015, 10, 21, 10, 22))
  end

  # asserting about the object
  it 'has some attributes' do
    user.email.should == 'alice@example.com'
    user.last_login.should == Time.new(2015, 10, 21, 10, 22)
  end

  # asserting against the object
  it 'has some attributes' do
    # user.should == User.new(email: 'alice@example.com', last_login: Time.new(2015, 10, 21, 10, 22))
    user.to_hash.should == {
      id: user.id,
      email: 'alice@example.com',
      last_login: Time.new(2015, 10, 21, 10, 22)
    }
  end

  it 'can change emails' do
    user.change_email('bob@example.com')
    user.email.should == 'bob@example.com'
  end
end