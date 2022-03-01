class RecipesController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

    def index
        if session[:user_id]
            render json: Recipe.all, status: 201
        else
            render json: {errors: [{error: "Unauthorized."}]}, status: 401
        end
    end

    def create
        recipe = Recipe.create! recipe_params
    end

    private

    def recipe_params
        params.permit :title, :instructions, :minutes_to_complete
    end

    def record_invalid invalid
        render json: invalid.record.errors, status: :unprocessable_entity
    end
end
