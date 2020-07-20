class CompaniesController < ApplicationController
  before_action :set_company, except: [:index, :create, :new]
  before_action :validate_email, only: [:create, :update]

  EMAIL_REGEX = /\A[\w+\-.]+@getmainstreet.com\z/i

  def index
    @companies = Company.all
  end

  def new
    @company = Company.new
  end

  def show
    @company_address_details  = ZipCodes.identify(@company.zip_code)
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to companies_path, notice: "Saved"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @company.update(company_params)
      redirect_to companies_path, notice: "Changes Saved"
    else
      render :edit
    end
  end

  def destroy
    @company.destroy
    redirect_to companies_path, notice: "Deleted Company"
  end

  private

  def company_params
    params.require(:company).permit(
      :name,
      :legal_name,
      :description,
      :zip_code,
      :phone,
      :email,
      :owner_id,
      )
  end

  def set_company
    @company = Company.find(params[:id])
  end

  def validate_email
    input_email = company_params[:email]
    if input_email.present?
      valid_email = EMAIL_REGEX.match?(input_email)
      unless valid_email
        @company = Company.new(company_params)
        flash[:error] = "Email address with domain '@getmainstreet.com' are only allowed!"
        render :new
      end
    end
  end

end
