module Hyrax
  class NotificationsController < ApplicationController
    before_action :authenticate_user!
    layout 'dashboard'

    def index
      add_breadcrumb t(:'hyrax.controls.home'), root_path
      add_breadcrumb t(:'hyrax.dashboard.breadcrumbs.admin'), hyrax.dashboard_path
      add_breadcrumb t(:'hyrax.admin.sidebar.notifications'), hyrax.notifications_path
      @messages = user_mailbox.inbox
    end

    def delete_all
      user_mailbox.delete_all
      redirect_to hyrax.notifications_path, alert: t('hyrax.mailbox.notifications_deleted')
    end

    def destroy
      message_id = params[:id]
      alert = user_mailbox.destroy(message_id)
      redirect_to hyrax.notifications_path, alert: alert
    end

    private

      def user_mailbox
        UserMailbox.new(current_user)
      end
  end
end
