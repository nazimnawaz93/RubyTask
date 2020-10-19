class UsersController < ApplicationController
    layout 'application'
    require 'rest-client'
    require 'json'
    def index
        
    end

    def signup
        @user = User.new
    end
    def createUser
        flash.clear
        @user = User.new(user_params)
        @user.status="Enabled";
        if @user.save
            flash[:success] = "You signed up successfully"
        else
            flash[:danger] = "Unable to create user"
        end
            render "signup"
    end

    def logout
        flash.clear
        if session[:current_user_id]
             reset_session
        end
        redirect_to action:'index';
     end

    def login
        flash.clear
        @user=User.where(email:params[:users][:email]).first;
        if !@user.blank?
            @hashed=BCrypt::Password.new(@user.encrypted_password);
            if BCrypt::Password.new(@user.encrypted_password) == params[:users][:password]
                if @user.status=="Enabled"
                    reset_session;
                    @user.update(last_login_date: Date.today);
                    session[:current_user_id] = @user[:id]
                    session[:current_user_role] = @user[:role]
                    if @user[:role] == "Staff"
                        redirect_to action:'market';
                    elsif @user[:role] =="Admin"
                        redirect_to action:'list';
                    else
                        flash[:danger] = "No user role is assigned to you";
                        redirect_to action:'index';
                    end
                else
                    flash[:danger] = "Your Account is locked contact your admin."
                    redirect_to action:'index';
                end
            else
                flash[:danger] = "Invalid username or password"
                redirect_to action:'index';
            end
        else
            flash[:danger] = "Invalid username or password"
            redirect_to action:'index';
        end 
    end
    def list
        if session[:current_user_role]=="Admin"
            @users=User.where(role:"Staff");
        elsif  session[:current_user_role]=="Staff" 
            redirect_to action:'market';
        end
    end

    def changeStatus
        begin
            @user=User.find(params[:id]);
            if @user[:status]=="Enabled"
                @user.update(status: "Disabled");
                flash[:success] = "Status changed successfully"
            else
                @user.update(status: "Enabled");
                flash[:success] = "Status changed successfully"
            end
                redirect_to action:'list';
        rescue => exception
            redirect_to action:'list';
            flash[:danger] = "Error while changing status"
        end
        
    end

    def market
        flash.clear
        begin
            if session[:current_user_role]=="Staff"
                @response = RestClient::Request.new(
                    :method => :get,
                    :url => 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=aud&order=market_cap_desc&per_page=100&page=1&sparkline=false',
                    :verify_ssl => false
                ).execute
                @currencies=JSON.parse(@response.to_str);
            elsif session[:current_user_role]=="Admin"
                flash[:danger]="You do not have permission to access this page"
                redirect_to action:'list';
            else
                flash[:danger]="Login to process further"
                redirect_to action:'index';
            end
        rescue => exception
            redirect_to action:'index';
        end
        
    end
    def user_params
        params.require(:user).permit(:name, :email,:role, :password, :password_confirmation, :encrypted_password)
    end
end
