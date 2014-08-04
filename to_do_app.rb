require "sinatra"
require "gschool_database_connection"
require "rack-flash"
require "active_record"
require "./lib/to_do_item"
require "./lib/user"

class ToDoApp < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    if current_user
      user = current_user

      users = User.where("id != #{user.id}")
      todos = ToDoItem.all
      erb :signed_in, locals: {current_user: user, users: users, todos: todos}
    else
      erb :signed_out
    end
  end

  get "/register" do
    erb :register, locals: {user: User.new}
  end

  post "/registrations" do
    user = User.new(username: params[:username], password: params[:password])

    if user.save
      flash[:notice] = "Thanks for registering"
      redirect "/"
    else
      erb :register, locals: {user: user}
    end
  end

  post "/sessions" do

    user = authenticate_user

    if user != nil
      session[:user_id] = user.id
    else
      flash[:notice] = "Username/password is invalid"
    end

    redirect "/"
  end

  delete "/sessions" do
    session[:user_id] = nil
    redirect "/"
  end

  post "/todos" do
    ToDoItem.create(body: params[:body])

    flash[:notice] = "ToDo added"

    redirect "/"
  end

  get "/todos/edit/:id" do
    todo = current_todo

    erb :edit, locals: {todo: todo}
  end

  patch "/todos/update/:id" do
    todo = current_todo
    todo.update(body: params[:edit_todo])
    flash[:notice] = "ToDo updated"
    redirect "/"
  end

  delete "/todos/complete/:id" do
    todo = current_todo
    todo.destroy
    redirect "/"
  end

  private

  def authenticate_user
    User.authenticate(params[:username], params[:password])
  end

  def current_user
    User.find_by(id: session[:user_id])
  end

  def current_todo
    ToDoItem.find(params[:id])
  end

end
