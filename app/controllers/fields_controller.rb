class FieldsController < ApplicationController
  def update
    @field = Field.find(params[:board_id])
    @field.update(field_params)
  end

  private
  def field_params
    params.require(:field).permit(:value)
  end
end
