class TemplatesController < ApplicationController
  respond_to :html

  def new
    @user = User.find
    @template_form = TemplateForm.new
  end
end
