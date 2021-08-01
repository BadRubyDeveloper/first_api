class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def index
  	users = User.all

  	render json: users, status: 200
  end

  def create
  	user = User.create(user_params)

  	if user.persisted?
  	  render json: user, status: 201
  	else
  	  render json: { message: "User not created!", errors: user.errors.full_messages }, status: 400
  	end
  end

  def show
  	if @user
  	  render json: @user, status: 200
  	else
  	  render json: { message: "User is not exist" }, status: 404
  	end
  end

  def update
  	if @user.update(user_params)
  	  render json: @user, status: 200
  	else
  	  render json: { message: "User is not updated!", errors: @user.errors.full_messages }, status: 400
  	end
  end

  def destroy
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
