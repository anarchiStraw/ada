class YouroomUsersController < ApplicationController
  # GET /youroom_users
  # GET /youroom_users.json
  def index
    @youroom_users = YouroomUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @youroom_users }
    end
  end

  # GET /youroom_users/1
  # GET /youroom_users/1.json
  def show
    @youroom_user = YouroomUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @youroom_user }
    end
  end

  # GET /youroom_users/new
  # GET /youroom_users/new.json
  def new
    @youroom_user = YouroomUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @youroom_user }
    end
  end

  # GET /youroom_users/1/edit
  def edit
    @youroom_user = YouroomUser.find(params[:id])
  end

  # POST /youroom_users
  # POST /youroom_users.json
  def create
    @youroom_user = YouroomUser.new(params[:youroom_user])

    respond_to do |format|
      if @youroom_user.save
        format.html { redirect_to @youroom_user, notice: 'Youroom user was successfully created.' }
        format.json { render json: @youroom_user, status: :created, location: @youroom_user }
      else
        format.html { render action: "new" }
        format.json { render json: @youroom_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /youroom_users/1
  # PUT /youroom_users/1.json
  def update
    @youroom_user = YouroomUser.find(params[:id])

    respond_to do |format|
      if @youroom_user.update_attributes(params[:youroom_user])
        format.html { redirect_to @youroom_user, notice: 'Youroom user was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @youroom_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /youroom_users/1
  # DELETE /youroom_users/1.json
  def destroy
    @youroom_user = YouroomUser.find(params[:id])
    @youroom_user.destroy

    respond_to do |format|
      format.html { redirect_to youroom_users_url }
      format.json { head :ok }
    end
  end
end
