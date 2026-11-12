class ConversationsController < ApplicationController
  before_action :authorize!, only: [:index, :show]

  def index
    @conversations = Conversation.includes(:user, product: { photos_attachments: :blob }).order(last_message_at: :desc, id: :desc)
  end

  def show
    conversation.mark_as_read!
  end

  private

  def conversation
    @conversation ||= Conversation.find(params[:id])
  end
end
