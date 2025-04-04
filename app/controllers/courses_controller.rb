class CoursesController < ApplicationController
  # Use :set_course before the specified actions
  before_action :authenticate_user!
  # before_action :authenticate_admin!
  before_action :set_course, only: [ :show, :edit, :update, :destroy ]

  # GET /courses or /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1 or /courses/1.json
  def show
    @course = Course.find(params[:id])
    @weeks = @course.weeks
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
    @course = Course.find(params[:id])
  end

  # POST /courses or /courses.json
  def create
    @course = current_user.courses.build(course_params)  # Associate course with current user

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_path, status: :see_other, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  rescue ActiveRecord::InvalidForeignKey
    render "errors/foreign_key_error", status: :unprocessable_entity
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_course
    @course = Course.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to errors_not_found_path
  end

    # Only allow a list of trusted parameters through.
    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(
        :course_name,
        :course_instructor,
        :course_grading_criteria,
        :courses_your_grade,
        :course_comments
      )
    end  # ✅ closes course_params
end  # ✅ closes class CoursesController
