class ConversationMessagesController < ApplicationController
  before_action :authorize!, only: :create

  def create
    message = conversation.add_message(user: Current.user, content: message_params[:content])

    if message.persisted?
      message.broadcast_to_conversation
      message.notify_recipient
      redirect_to conversation_path(conversation)
    else
      redirect_to conversation_path(conversation), alert: message.errors.full_messages.to_sentence
    end
  end

  private

  def conversation
    @conversation ||= Conversation.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
