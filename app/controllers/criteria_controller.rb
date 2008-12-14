class CriteriaController < ApplicationController
  def new
    @criterion = Criterion.new
    @criterion.field = params[:field] || Criterion.fields.first

    respond_to do |format|
      format.html { redirect_to(profiles_path) }
      format.js # new.js.rjs
    end
  end
end
