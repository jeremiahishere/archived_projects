class FeaturesController < ApplicationController
  before_action :set_project
  before_action :set_feature, only: [:show, :edit, :update, :destroy]

  def suggestions
    partial_match = params[:line] || ""
    best_lines = Feature.suggestions_for_project(@project, partial_match)

    render :json => best_lines
  end

  # GET /features
  def index
    @project.find_features

    @features = Feature.all
  end

  # GET /features/1
  def show
  end

  # GET /features/new
  def new
    @feature = Feature.new
  end

  # GET /features/1/edit
  def edit
  end

  # POST /features
  def create
    @feature = Feature.new(feature_params)

    if @feature.save
      @feature.write_base_file
      redirect_to project_feature_path(@project, @feature), notice: 'Feature was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /features/1
  def update
    if @feature.update(feature_params)
      @feature.write_base_file
      redirect_to project_feature_path(@project, @feature), notice: 'Feature was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /features/1
  def destroy
    @feature.destroy
    redirect_to project_features_url(@project), notice: 'Feature was successfully destroyed.'
  end

  private
    def set_project
      @project = Project.find(params[:project_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_feature
      @feature = Feature.find(params[:id])
      @feature.read_base_file
      @feature.save
      @feature
    end

    # Only allow a trusted parameter "white list" through.
    def feature_params
      params.require(:feature).permit(:project_id, :path, :contents)
    end
end
