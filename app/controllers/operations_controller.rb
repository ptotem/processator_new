class OperationsController < ApplicationController
  # GET /operations
  # GET /operations.json
  def index
    @operations = Operation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @operations }
    end
  end

  def case_oper
    @case_study=CaseStudy.find(params[:cs_id])
    @operations=@case_study.operations
    render :layout => false
  end

  # GET /operations/1
  # GET /operations/1.json
  def show
    @operation = Operation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @operation }
    end
  end

  # GET /operations/new
  # GET /operations/new.json
  def new
    @operation = Operation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @operation }
    end
  end

  # GET /operations/1/edit
  def edit
    @operation = Operation.find(params[:id])
  end

  # POST /operations
  # POST /operations.json
  def create
    @operation = Operation.new(params[:operation])

    respond_to do |format|
      if @operation.save
        format.html { redirect_to @operation, notice: 'Operation was successfully created.' }
        format.json { render json: @operation, status: :created, location: @operation }
      else
        format.html { render action: "new" }
        format.json { render json: @operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /operations/1
  # PUT /operations/1.json
  def update
    @operation = Operation.find(params[:id])

    respond_to do |format|
      if @operation.update_attributes(params[:operation])
        format.html { redirect_to @operation, notice: 'Operation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /operations/1
  # DELETE /operations/1.json
  def destroy
    @operation = Operation.find(params[:id])
    @operation.destroy

    respond_to do |format|
      format.html { redirect_to operations_url }
      format.json { head :no_content }
    end
  end

  def draw_tree
    @operation = Operation.find(params[:id])
    @steps=Step.find_all_by_operation_id(@operation.id)
    @correct_path=OperationMap.find_all_by_case_study_id_and_operation_id(@operation.case_studies.first.id,@operation.id).first.sequence
    @correct_steps=Array.new
    @correct_path.split(',').each do |e|
      @correct_steps<<Step.find(e.to_i)
    end
    @count=0
  end

  def check
    @user=current_user
    @operation=Operation.find(params[:id])
    @correct_path=OperationMap.find_all_by_case_study_id_and_operation_id(@operation.case_studies.first.id,@operation.id).first.sequence.split(',')[params[:index].to_i]
    if params[:selected]==@correct_path
        @user.reputation=@user.reputation+1
        @user.save
      render :text=>"y|#{@correct_path}|#{params[:selected]}|#{params[:index].to_i+1}|#{@operation.case_studies.first.id}|#{@user.reputation}"
      return
    else
      if @user.reputation>0
        @user.reputation=@user.reputation-2
        @user.save
      end
      render :text=>"n|#{@correct_path}|#{params[:selected]}|#{params[:index].to_i+1}|#{@user.reputation}"
      return
    end


  end

  def play
    @operation=Operation.find(params[:id])
    @step=Step.find(params[:step_id])
    @remaining_time=params[:rt].to_i
    @count=params[:count].to_i
    @options=@step.hierarchies.count+1
    @option_value=Array.new
    @step.hierarchies.each do |s|
      @option_value<<s.son
    end
    @option_value<<(Step.find_all_by_operation_id(@operation.id)-@option_value).sample
    @option_value<<(Step.find_all_by_operation_id(@operation.id)-@option_value).sample
    if @option_value.count>3
      @option_value=@option_value[0..2]
    end
    @option_value=@option_value.shuffle
    @correct_path=OperationMap.find_all_by_case_study_id_and_operation_id(@operation.case_studies.first.id,@operation.id).first.sequence
    @user=current_user
    @status=@user.status
    @user.reputation = params[:repu].to_i
    @user.status=true
    @user.save
    @question=@step.questions.first
    render :layout => false
  end

  def check_quiz
    @user=current_user
    @question=Question.find(params[:id])
    if(params[:selected]==@question.correct.downcase)
        @user.reputation=@user.reputation+1
        @user.save
      render :text=>"y|#{@user.reputation}"
      return
    else
      if @user.reputation>0
        @user.reputation=@user.reputation-2
        @user.save
      end
      render :text=>"n|#{@user.reputation}"
      return
    end
  end

  def time_over
    @user=current_user
    if @user.reputation>0
    @user.reputation=@user.reputation-2
    @user.save
    end
    render :text=>@user.reputation
    return
  end

  def game_over
    @user=current_user
    @rep=@user.reputation
    @time_remaining=params[:time].to_i
    @user.reputation=@user.reputation+@time_remaining/1000;
    @user.save
    render :layout => false
  end
end
