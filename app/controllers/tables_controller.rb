class TablesController < ApplicationController
  before_filter :require_authentication
  before_filter :set_table_and_require_authorization, only: [:edit, :update, :show]
  before_filter :convert_data_string_to_JSON, only: [:create, :update]

  def create
    @table= current_user.tables.build(table_params)
    if @table.save
      flash[:success] = "Table created"
      redirect_to @table
    else
      flash[:error] = @table.errors.full_messages
      render 'new'
    end
  end

  def show
  end

  def new
    @table = Table.new
  end

  def edit
  end

  def update
    @table.update_attributes(table_params)
    if @table.save!
      flash[:success] = "Table updated"
      redirect_to @table
    else
      render 'edit'
    end
  end

  private

  def table_params
    strong_params = params.require(:table).permit(:name, :data_source)
    if (p = params[:table]) && self.class.valid_data?(p[:data])
      strong_params[:data] = p[:data]
    end
    strong_params
  end

  def self.valid_data?(rows)
    return false unless rows.class == Array
    rows.each do |row|
      return false unless row.class == Array
      row.each {|e| return false unless [String, Fixnum, Float].include? e.class}
    end
    true
  end

  def set_table_and_require_authorization
    @table = Table.find(params[:id])
    flash[:error] = 'Not authorized for that operation' and redirect_to(root_path) unless current_user.id==@table.user_id
  end

  def convert_data_string_to_JSON
    params[:table][:data] = JSON[params[:table][:data]] if !params[:table][:data].empty?
  end

end
