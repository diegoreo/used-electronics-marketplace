class ConversationsController < ApplicationController
  before_action :authorize!, only: [:index, :show, :read]

  def index
    @conversations = Conversation.includes(:user, product: { photos_attachments: :blob }).order(last_message_at: :desc, id: :desc)
  end

  def show
    @conversation = conversation
  end

  def read
    conversation.mark_as_read!
    head :no_content
  end

  private

  def conversation
    @conversation ||= Conversation.find(params[:id])
  end
end
