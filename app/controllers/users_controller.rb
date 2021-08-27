class UsersController < ApplicationController
  include UsersPolicy
  before_action :authenticate!, only: [:index, :update, :show, :destroy]
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    return render_unauthorize unless can_read?(@current_user)
    
  	users = User.all

  	render json: users, status: 200
  end

  def create
  	user = User.new(user_params)
    user.password = Base64.encode64(user_params[:password])

  	if user.save
  	  render json: user, status: 201
  	else
  	  render json: { message: "User not created!", errors: user.errors.full_messages }, status: 400
  	end
  end

  def show
    return render_unauthorize unless can_update?(@user, @current_user)

  	if @user
  	  render json: @user, status: 200
  	else
  	  render json: { message: "User is not exist" }, status: 404
  	end
  end

  def update
    return render_unauthorize unless can_update?(@user, @current_user)

  	if @user.update(user_params)
      @user.update(password: Base64.encode64(user_params[:password])) if user_params[:password]

  	  render json: @user, status: 200
  	else
  	  render json: { message: "User is not updated!", errors: @user.errors.full_messages }, status: 400
  	end
  end

  def destroy
    return render_unauthorize unless can_delete?(@current_user)

  	if @user.destroy
  	  render json: "User was deleted", status: 204
  	end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def set_user
    @user = User.find_by!(id: params[:id])
  end
end
