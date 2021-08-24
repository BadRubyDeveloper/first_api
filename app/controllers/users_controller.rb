class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    # Can read only admin
  	users = User.all

  	render json: users, status: 200
  end

  def create
    # Can create all
  	user = User.new(user_params)
    user.password = Base64.encode64(user_params[:password])

  	if user.save
  	  render json: user, status: 201
  	else
  	  render json: { message: "User not created!", errors: user.errors.full_messages }, status: 400
  	end
  end

  def show
    # Can read only self, or admin
  	if @user
  	  render json: @user, status: 200
  	else
  	  render json: { message: "User is not exist" }, status: 404
  	end
  end

  def update
    # Can write only self or admin
  	if @user.update(user_params)
  	  render json: @user, status: 200
  	else
  	  render json: { message: "User is not updated!", errors: @user.errors.full_messages }, status: 400
  	end
  end

  def destroy
    # Can write only admin
  	if @user.destroy
  	  render json: "User was deleted", status: 204
  	end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def set_user
    @user = User.find_by(id: params[:id])
  end
end
