class TeachersController < ApplicationController

  def index
    @teachers = Teacher.all
    @locations = Location.all.map(&:name)
  end

  def show
    @teacher = Teacher.find(params[:id])
  end

  def feedback
    @teacher = Teacher.find(params[:id])
    @feedback = @teacher.feedbacks.find_or_create_by(student: current_user, feedbackable: nil)
    render 'feedbacks/modal_content', layout: false
  end

end
