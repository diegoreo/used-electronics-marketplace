class ProductMessagesController < ApplicationController
  before_action :authorize!, only: [:create, :read]

  def create
    message = nil

    Conversation.transaction do
      conversation = Conversation.for(product: product, user: Current.user)
      message = conversation.add_message(user: Current.user, content: message_params[:content])
      raise ActiveRecord::Rollback unless message.persisted?
    end

    if message.persisted?
      message.broadcast_to_conversation
      message.notify_recipient
      redirect_to product_path(product, scroll_to_chat: true)
    else
      redirect_to product_path(product, scroll_to_chat: true), alert: message.errors.full_messages.to_sentence
    end
  end

  def read
    conversation&.mark_as_read_by_buyer!
    head :no_content
  end

  private

  def product
    @product ||= Product.find(params[:product_id])
  end

  def conversation
    @conversation ||= Conversation.find_by(product: product, user: Current.user)
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
