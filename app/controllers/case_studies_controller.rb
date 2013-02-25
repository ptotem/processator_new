class CaseStudiesController < ApplicationController
  # GET /case_studies
  # GET /case_studies.json
  def index
    @case_studies = CaseStudy.all
    render :layout => false
    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.json { render json: @case_studies }
    #end
  end

  # GET /case_studies/1
  # GET /case_studies/1.json
  def show
    @case_study = CaseStudy.find(params[:id])
    render :layout => false
    #respond_to do |format|
    #  format.html # show.html.erb
    #  format.json { render json: @case_study }
    #end
  end

  # GET /case_studies/new
  # GET /case_studies/new.json
  def new
    @case_study = CaseStudy.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @case_study }
    end
  end

  # GET /case_studies/1/edit
  def edit
    @case_study = CaseStudy.find(params[:id])
  end

  # POST /case_studies
  # POST /case_studies.json
  def create
    @case_study = CaseStudy.new(params[:case_study])

    respond_to do |format|
      if @case_study.save
        format.html { redirect_to @case_study, notice: 'Case study was successfully created.' }
        format.json { render json: @case_study, status: :created, location: @case_study }
      else
        format.html { render action: "new" }
        format.json { render json: @case_study.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /case_studies/1
  # PUT /case_studies/1.json
  def update
    @case_study = CaseStudy.find(params[:id])

    respond_to do |format|
      if @case_study.update_attributes(params[:case_study])
        format.html { redirect_to @case_study, notice: 'Case study was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @case_study.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /case_studies/1
  # DELETE /case_studies/1.json
  def destroy
    @case_study = CaseStudy.find(params[:id])
    @case_study.destroy

    respond_to do |format|
      format.html { redirect_to case_studies_url }
      format.json { head :no_content }
    end
  end

  require 'spreadsheet'
  require 'graphviz'

  def excel_imp

    #To open excel and importing it into database
    @process=Array.new
    @operations=Array.new
    @steps=Array.new
    @hierarchies=Array.new
    @questions=Array.new

    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet.open '/home/sunny/qfts.xls'
    sheet1 = book.worksheet 0
    sheet2 = book.worksheet 1
    sheet3 = book.worksheet 2
    sheet4 = book.worksheet 5

    @last_operation_id=Operation.all.last.id+1

    sheet1.each_with_index do |row, index|
      if index>0
        @operations<<Operation.create!(:id => @last_operation_id+row[2].to_i, :name => row[0], :description => row[1])
      end
    end

    @last_step_id=20

    sheet2.each_with_index do |row, index|
      if index>0
        @steps<<Step.create!(:id => @last_step_id+row[0].to_i, :name => row[1], :description => row[2], :operation_id => @last_operation_id-1+row[3], :shape => row[4])
      end
    end

    sheet3.each_with_index do |row, index|
      if index>0
        row[1].split(/,/).each_with_index do |s, j|
          if !row[2].nil?
            @hierarchies<<Hierarchy.create!(:step_id => @last_step_id+row[0].to_i, :son_id => @last_step_id+s.to_i, :label => row[2].split(',')[j])
          else
            @hierarchies<<Hierarchy.create!(:step_id => @last_step_id+row[0].to_i, :son_id => @last_step_id+s.to_i)
          end
        end
      end
    end

    sheet4.each_with_index do |row, index|
      if index>0
        @questions<<Question.create!(:description=>row[2],:optionA=>row[3],:optionB=>row[4],:optionC=>row[5],:correct=>row[6],:step_id=>@last_step_id+row[7].to_i)
      end
    end

    #To generate flow chart
    g = GraphViz.new(:G, :type => :digraph)
    @hierarchies.each do |son|
      g.add_edges(g.add_nodes(Step.find(son.step_id).name, :shape => Step.find(son.step_id).shape), g.add_nodes(Step.find(son.son_id).name),:label=>son.label)
    end

    n=g.output(:png => "/home/sunny/qfts.png")

    render :text=>'Sunny'
    return
  end

end
