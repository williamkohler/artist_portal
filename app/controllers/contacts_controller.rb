class ContactsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user, only: :destroy

  def index
    if params[:search]
      @contacts = (Contact.search params[:search]).paginate(page: 1)
    else
      @contacts = Contact.all.paginate(page: params[:page], per_page: 10)
    end
  end

  def new
    @contact = Contact.new
  end

  def show
    @contact = Contact.find(params[:id])
    @shows = @contact.promoter_shows.paginate(page: params[:page], per_page: 5)
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      flash[:success] = "#{@contact.name} successfully created."
      redirect_to contacts_path
    else
      flash[:warning] = 'Unable to create contact.'
      render 'new'
    end
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def update
    @contact = Contact.find(params[:id])
    if @contact.update_attributes(contact_params)
      flash[:success] = "#{@contact.name} updated."
      redirect_to contacts_path
    else
      render 'edit'
    end
  end

  def destroy
    contact = Contact.find(params[:id])
    flash[:success] = "#{contact.name} deleted."
    contact.destroy
    redirect_to contacts_path
  end

  def shows
    @contact = Contact.find(params[:id])
    @shows = @contact.promoter_shows.paginate(page: params[:page], per_page: 10)
  end

  private

  def contact_params
    params.require(:contact).permit!
  end
end
