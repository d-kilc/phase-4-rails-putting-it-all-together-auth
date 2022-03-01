class SessionsController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def create
        user = User.find_by! username: params[:username]
        if user&.authenticate params[:password]
            session[:user_id] = user.id
            render json: user, status: :ok
        else
            render json: {errors: "Invalid credentials"}, status: :unauthorized
        end
    end

    def destroy
        if session[:user_id]
            session.delete :user_id
            head :no_content 
        else
            render json: {errors: [{error: "Unauthorized"}]}, status: :unauthorized
        end
        
    end

    private

    def record_invalid invalid
        render json: {errors: invalid.record.errors.to_a}, status: :unauthorized
    end

    def record_not_found
        render json: {errors: [{error: "couldnt find user"}]}, status: :unauthorized
    end

end
