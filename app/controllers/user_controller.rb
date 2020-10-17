class UserController < ApplicationController
end
class UserController < ApplicationController
    layout 'application'
    require 'rest-client'
    require 'json'
    def index
        reset_session
    end

    def logout
        if session[:current_user_id]
             reset_session
        end
        redirect_to action:'index';
     end

    def login
        begin
            @user=User.where(Email:params[:users][:email], Password:params[:users][:password],Status:"Enabled").first;
            if !@user.blank?
                @user.update(LastLoginDate: Date.today);
                session[:current_user_id] = @user[:id]
                session[:current_user_role] = @user[:Role]
                if @user[:Role] == "Staff"
                    redirect_to action:'market';
                elsif @user[:Role] =="Admin"
                    redirect_to action:'list';
                else
                redirect_to action:'index';
                end
            else
                redirect_to action:'index';
            end 
        rescue => exception
            redirect_to action:'index';
        end
    end
    def list
        if session[:current_user_role]=="Admin"
            @users=User.where(Role:"Staff");
        elsif  session[:current_user_role]=="Staff" 
            redirect_to action:'market';
        end
    end

    def changeStatus
        begin
            @user=User.find(params[:id]);
            if @user[:Status]=="Enabled"
                @user.update(Status: "Disabled");
            else
                @user.update(Status: "Enabled");
            end
                redirect_to action:'list';
        rescue => exception
            redirect_to action:'list';
        end
        
    end

    def market
        begin
            if session[:current_user_role]=="Staff"
                @response = RestClient::Request.new(
                    :method => :get,
                    :url => 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=aud&order=market_cap_desc&per_page=100&page=1&sparkline=false',
                    :verify_ssl => false
                ).execute
                @currencies=JSON.parse(@response.to_str);
            elsif session[:current_user_role]=="Admin"
                redirect_to action:'list';
            else
                redirect_to action:'index';
            end
        rescue => exception
            redirect_to action:'index';
        end
        
    end
    
end
