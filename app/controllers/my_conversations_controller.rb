class MyConversationsController < ApplicationController
  before_action :authorize!, only: :index

  def index
    @conversations = Conversation.where(user: Current.user).includes(product: { photos_attachments: :blob }).order(last_message_at: :desc, id: :desc)
  end
end
