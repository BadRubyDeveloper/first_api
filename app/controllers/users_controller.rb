class UsersController < ApplicationController
  def index
  	users = User.all

  	render json: users, status: 200
  end

  def create
  	user = User.create(name: params[:name], email: params[:email], password: params[:password])

  	if user.persisted?
  	  render json: user, status: 201
  	else
  	  render json: { errors: user.errors.full_messages }, status: 400
  	end
  end

  def show
  	user = User.find_by(id: params[:id])

  	unless user.nil?
  	  render json: user, status: 200
  	else
  	  render json: { message: "User is not exist" }, status: 404
  	end
  end

  def update
  	user = User.find_by(id: params[:id])

  	if user.update(email: params[:email], password: params[:password], name: params[:name])
  	  render json: user, status: 200
  	else
  	  render json: { errors: user.errors.full_messages }, status: 400
  	end
  end

  def destroy
  	user = User.find_by(id: params[:id])

  	if user.destroy
  	  render json: "User was deleted", status: 204
  	end
  end
end
