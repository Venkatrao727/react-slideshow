class SlidesController < ApplicationController
	protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
	def new 
		@slide = Slide.new
	end
	
	def index
		@slides = Slide.all
		respond_to do |format|
			format.json { render json: @slides}
		end
	end

	def show
		@slide = Slide.find(params[:id])
		respond_to do |format|
			format.json { render json: @slide}
		end
	end

	def create
		@slide = Slide.new(slide_params)
		
		Slide.where("position >= ?", @slide.position).each do |slide| 
			slide.position = slide.position+1
			slide.save
		end
		
		@slide.save!
		
		respond_to do |format|
			format.json { render json: @slide}
		end 
	end

	def update
		@slide = Slide.find(params[:id])
		@slide.update_attributes(slide_params)
		respond_to do |format|
			format.json { render json: @slide}
		end
	end

	def destroy
		@slide = Slide.find(params[:id])
		Slide.where("position > ?", @slide.position).each do |slide|
			slide.position = slide.position-1
			slide.save
		end
		@slide.destroy
		respond_to do |format|
			format.json { head :no_content }	
		end
	end

	private
	  def slide_params
	    params.require(:slide).permit(:title, :content, :position)
	  end
end
