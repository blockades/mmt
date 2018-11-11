# frozen_string_literal: true

module Admins
  class TransactionCommentsController < AdminsController
    def create
      @comment = transaction.comments.create(comment_params)

      respond_to do |format|
        if @comment.persisted?
          format.js
        else
          format.js
        end
      end
    end

    private

    def permitted_params
      params.require(:annotations_comment).permit(:body)
    end

    def comment_params
      permitted_params.merge(
        member: current_member,
        type: Annotations::Comment,
        annotatable_type: @transaction.class
      )
    end

    def transaction
      @transaction = Transactions::Base.find(params[:transaction_id])
    end
  end
end
