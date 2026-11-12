class ProductMessagesController < ApplicationController
  before_action :authorize!, only: :create

  def create
    message = nil

    Conversation.transaction do
      conversation = Conversation.for(product: product, user: Current.user)
      message = conversation.add_message(user: Current.user, content: message_params[:content])
      raise ActiveRecord::Rollback unless message.persisted?
    end

    if message.persisted?
      message.broadcast_to_conversation
      redirect_to product_path(product)
    else
      redirect_to product_path(product), alert: message.errors.full_messages.to_sentence
    end
  end

  private

  def product
    @product ||= Product.find(params[:product_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
