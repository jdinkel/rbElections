class ElectionsController < ApplicationController
  # GET /elections
  # GET /elections.xml
  def index
    @elections = Election.all
    @title = 'All Elections'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @elections }
    end
  end

  # GET /elections/1
  # GET /elections/1.xml
  def show
    @election = Election.find(params[:id])
    @title = @election.title

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @election }
    end
  end

  # GET /elections/new
  def new
    @election = Election.new
    @title = 'New Election'
    @form_button_text = 'Create'
  end

  # GET /elections/1/edit
  def edit
    @election = Election.find(params[:id])
    @title = "Edit #{@election.title}"
    @form_button_text = 'Update'
  end

  # POST /elections
  def create
    @election = Election.new(params[:election])

    if @election.save
      redirect_to(@election, :notice => 'Election will be created shortly.')
    else
      render :action => "new"
    end
  end

  # PUT /elections/1
  def update
    @election = Election.find(params[:id])

    if @election.update_attributes(params[:election])
      redirect_to(@election, :notice => 'Election will be updated shortly.')
    else
      render :action => "edit"
    end
  end

  # DELETE /elections/1
  def destroy
    @election = Election.find(params[:id])
    @election.destroy

    redirect_to(elections_url)
  end
end
