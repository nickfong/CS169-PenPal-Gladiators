require 'spec_helper'

describe Conversation do
    context "when using a conversation instance" do
        before :each do
            @ben = User.create! :email => "ben@bitdiddle.com", :password => "asdfasdf"
            @bob = User.create! :email => "bob@schmitt.com", :password => "asdfasdf"
            @arena = Arena.create! :user1 => @ben, :user2 => @bob
            @conversation = @arena.conversations.create! :title => "Happy feet"
            @post1 = @conversation.posts.create! :text => "Lalalala", :author => @ben
            Timecop.freeze Time.now
            @post2 = @conversation.posts.create! :text => "Good conversation", :author => @bob
            Timecop.return
        end

        it "should return the most recent post" do
            expect(@conversation.recent_post).to eq(@post2)
        end

        it "should return the appropriate update time" do
            expect(String(@conversation.timestamp)).to eq(String(@post2.updated_at))
        end

        it "should have the appropriate response object" do
            result = @conversation.response_object
            expect(result[:id]).to eq(@conversation.id)
            expect(result[:title]).to eq(@conversation.title)
            expect(result[:posts].length).to eq(@conversation.posts.length)
            expect(result[:summaries].length).to eq(2)
        end

        it "should initialize summary texts to empty strings" do
            expect(@conversation.summary_of_first).to eq ""
            expect(@conversation.summary_of_second).to eq ""
        end

        it "should allow users to edit opposing summaries" do
            @conversation.user_did_edit_summary(@ben.id, "summary of bob")
            @conversation.user_did_edit_summary(@bob.id, "summary of ben")
            expect(@conversation.summary_of_second).to eq "summary of bob"
            expect(@conversation.summary_of_first).to eq "summary of ben"
            @conversation.user_did_edit_summary(0, "I am neither ben or bob")
            expect(@conversation.summary_of_second).to eq "summary of bob"
            expect(@conversation.summary_of_first).to eq "summary of ben"
        end

        it "should allow users to approve opposing summaries" do
            @conversation.user_did_edit_summary(@ben.id, "summary of bob")
            @conversation.user_did_edit_summary(@bob.id, "summary of ben")
            @conversation.user_did_approve_summary(0)
            expect(@conversation.posts.length).to eq(2)
            # Check that Ben can approve Bob.
            @conversation.user_did_approve_summary(@ben.id)
            expect(@conversation.summary_of_first).to eq ""
            expect(@conversation.posts.last.text).to eq "summary of ben"
            expect(@conversation.posts.last.author).to eq @bob
            expect(@conversation.posts.last.post_type).to eq :summary
            # Check that Bob can approve Ben.
            @conversation.user_did_approve_summary(@bob.id)
            expect(@conversation.summary_of_second).to eq ""
            expect(@conversation.posts.last.text).to eq "summary of bob"
            expect(@conversation.posts.last.author).to eq @ben
            expect(@conversation.posts.last.post_type).to eq :summary
        end

        it "should allow both users to edit the resolution" do
            @conversation.user_did_edit_resolution(@ben.id, "this is Ben writing the resolution")
            expect(@conversation.resolution).to eq "this is Ben writing the resolution"
            expect(@conversation.resolution_updated_by_id).to eq @ben.id
            expect(@conversation.resolution_state).to eq :in_progress
            expect(@conversation.user_did_edit_resolution(@bob.id, "this is Bob writing the resolution")).to eq true
            expect(@conversation.resolution_updated_by_id).to eq @bob.id
            expect(@conversation.resolution_state).to eq :in_progress
        end

        it "should allow the other user to approve the resolution" do
            @conversation.user_did_edit_resolution(@ben.id, "this is Ben writing the resolution")
            expect(@conversation.user_did_approve_resolution(@bob.id)).to eq true
            expect(@conversation.resolution_state).to eq :consensus_reached
        end

        it "should not allow the same user to approve the resolution" do
            @conversation.user_did_edit_resolution(@ben.id, "this is Ben writing the resolution")
            expect(@conversation.user_did_approve_resolution(@ben.id)).to eq false
            expect(@conversation.resolution_state).to eq :in_progress
        end

        it "should not allow editing the resolution after consensus is reached" do
            @conversation.user_did_edit_resolution(@ben.id, "this is Ben writing the resolution")
            @conversation.user_did_approve_resolution(@bob.id)
            expect(@conversation.user_did_edit_resolution(@ben.id, "hello?")).to eq false
            expect(@conversation.resolution_state).to eq :consensus_reached
        end
    end
end
