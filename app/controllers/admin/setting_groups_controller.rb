class Admin::SettingGroupsController < ApplicationController
  before_action :set_setting_group, only: [:show, :update]

  def index
    @q = SettingGroup.search(params[:q])
    @setting_groups = @q.result.page(params[:page])
  end

  def show; end

  def update
    if @setting_group.update(setting_group_params)
      redirect_to [:admin, @setting_group]
    else
      render 'show'
    end
  end

  private

  def set_setting_group
    @setting_group = SettingGroup.find(params[:id])
  end

  def setting_group_params
    params.require(:setting_group).permit(settings_attributes: [:value, :id])
  end
end
