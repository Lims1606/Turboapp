class MessagesController < ApplicationController
  before_action :set_message, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [ :index, :show ]

  def index
    @messages = Message.order(created_at: :desc)
  end

  def show
  end

  def new
    @message = Message.new
  end

  def edit
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(@message, partial: "messages/form", locals: { message: @message })
      end
    end
  end

  def create
    @message = Message.new(message_params)
    @message = current_user.messages.build(message_param)

    respond_to do |format|
      if @message.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("new_message", partial: "messages/form", locals: { message: Message.new }),
            turbo_stream.prepend("messages", partial: "messages/message", locals: { message: @message }),
            turbo_stream.update("message_counter", Message.count),
            turbo_stream.update("notice", "Message Created Successfully!")
          ]
        end
        format.html { redirect_to @message, notice: "Message was successfully created." }
        format.json { render :show, status: :created, location: @message }
      else
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("new_message", partial: "messages/form", locals: { message: @message })
          ]
        end
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @message.update(message_params)
        format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(@message, partial: "messages/message", locals: { message: @message }),
          turbo_stream.update("notice", "Message Updated Successfully!")
        ]
      end
        format.html { redirect_to @message, notice: "Message was successfully updated." }
        format.json { render :show, status: :ok, location: @message }
      else
        format.turbo_stream do
        render turbo_stream: turbo_stream.update(@message, partial: "messages/form", locals: { message: @message })
      end
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @message = current_user.messages.find(params[:id])
    @message.destroy!

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@message),
          turbo_stream.update("message_counter", Message.count),
          turbo_stream.update("notice", "Message Deleted Successfully!")
      ]
      end
      format.html { redirect_to messages_path, status: :see_other, notice: "Message was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_message
      @message = Message.find(params[:id])
    end

    def message_params
      params.require(:message).permit(:body)
    end
end
