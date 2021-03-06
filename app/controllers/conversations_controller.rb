class ConversationsController < ApplicationController

    SUCCESS_MESSAGES = {
        :edited_summary => "successfully edited summary",
        :approved_summary => "successfully approved summary",
        :edited_resolution => "successfully edited resolution",
        :approved_resolution => "successfully approved resolution",
        :updated_title => "successfully updated conversation title"
    }

    def get_by_id
        conversation = Conversation.find_by_id(params[:id])
        if conversation.present?
            render :json => conversation.response_object
        else
            render_error :no_such_conversation
        end
    end

    def get_public_content
        conversation = Conversation.find_by_id params[:id]
        if conversation.present?
            render :json => conversation.public_content
        else
            render_error(:resource_not_found, :resource => :conversation)
        end
    end

    def get_with_resolutions
        conversations = Conversation.recent_with_resolutions(20).map { |conversation|
            {
                :id => conversation.id,
                :title => conversation.title,
                :resolution => conversation.resolution
            }
        }
        render :json => { :conversations => conversations }
    end

    def create
        user = @token_results[:user]
        other_user = User.find_by_id(params[:user_id])

        if other_user.present?
            arenas = Arena.for_users(user, other_user)

            if arenas.length == 0
                render_error(:resource_not_found, :resource => :arena)
            end

            arena = arenas[0]
            conversation = arena.conversations.create :title => "Untitled Conversation"
            render :json => { :id => conversation.id }
        else
            render_error(:resource_not_found, :resource => :other_user)
        end
    end

    def edit_title
        unless did_extract_arguments_from_params
            render_error :resource_not_found and return
        end
        arena = @conversation.arena
        if arena.user1_id == @user.id || arena.user2_id == @user.id
            @conversation.update_column :title, @text
            render :json => { :success => SUCCESS_MESSAGES[:updated_title] }
        else
            render_error :invalid_action
        end
    end

    def approve_summary
        edit_or_approve_resolution_or_summary :user_did_approve_summary, :approved_summary, :approve
    end

    def edit_summary
        edit_or_approve_resolution_or_summary :user_did_edit_summary, :edited_summary, :edit
    end

    def approve_resolution
        edit_or_approve_resolution_or_summary :user_did_approve_resolution, :approved_resolution, :approve
    end

    def edit_resolution
        edit_or_approve_resolution_or_summary :user_did_edit_resolution, :edited_resolution, :edit
    end

    private
    def edit_or_approve_resolution_or_summary(conversation_handler, success_message_key, edit_or_approve)
        unless did_extract_arguments_from_params
            render_error :no_such_conversation_or_user and return
        end
        if successfully_edited_or_approved conversation_handler, edit_or_approve
            render :json => { :success => SUCCESS_MESSAGES[success_message_key] }
        else
            render_error :invalid_action
        end
    end

    def successfully_edited_or_approved(conversation_handler, edit_or_approve)
        if edit_or_approve == :edit
            return @conversation.send conversation_handler, @user.id, @text
        elsif edit_or_approve == :approve
            return @conversation.send conversation_handler, @user.id
        end
    end

    def did_extract_arguments_from_params
        @text = params[:text] || ""
        @user = @token_results[:user]
        if @user.nil? || params[:conversation_id].nil?
            return false
        end
        @conversation = Conversation.find_by_id(params[:conversation_id])
        return @conversation.present?
    end
end
