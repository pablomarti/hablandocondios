class UsersController < ApplicationController

  before_filter :authenticate_user!
  before_action :only_admins
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.paginate(:per_page => 20, :page => params[:page])
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @curriculums = @user.curriculums
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.generate_password
    @user.generate_code

    respond_to do |format|
      if @user.save
        AdminMailer.new_user(@user).deliver

        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.make_inactive
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully deactivated.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      if params[:user][:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end

      params.require(:user).permit(:country_id, :level_id, :first_name, :last_name, :email, :birthdate, :address, :phone_number1, :phone_number2, :gender, :active)
    end
end
