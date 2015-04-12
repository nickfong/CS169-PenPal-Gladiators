require "digest"

############################################################
# Users
############################################################

users = [
    { :email => "ben@bitdiddle.com", :password => "bitsrocks" },
    { :email => "generic@email.com", :password => "asdfasdf" },
    { :email => "bob@schmitt.com", :password => "imboring" },
    { :email => "genericasiankid@gmail.com", :password => "password" },
    { :email => "rosenthal@policy.com", :password => "publicpolicy" }
]

users.each do |u|
    User.create!(u)
end

############################################################
# Survey Topics, Questions, and Responses
############################################################

responses = [
    { :text => "Yes", :index => 0 },
    { :text => "No", :index => 1}
]

topics = [
    { :name => "Climate", :icon => "/assets/topic_icons/climate.png"},
    { :name => "Education", :icon => "/assets/topic_icons/education.png"},
    { :name => "Economy", :icon => "/assets/topic_icons/money.png"},
    { :name => "Technology", :icon => "/assets/topic_icons/technology.png"},
    { :name => "LGBT Rights", :icon => "/assets/topic_icons/lgbt.png"},
    { :name => "Immigration", :icon => "/assets/topic_icons/immigration.png"},
    { :name => "Foreign Policy", :icon => "/assets/topic_icons/international.png"},
    { :name => "Religion", :icon => "/assets/topic_icons/religion.png"},
    { :name => "Philosophy", :icon => "/assets/topic_icons/philosophy.png"},
    { :name => "Criminal Law", :icon => "/assets/topic_icons/justice.png"},
]

topics.each do |t|
    topic = Topic.create!(t)

    survey_question1 = topic.survey_questions.create(:text => "Do you hate #{topic.name}?", :index => 1)
    survey_question2 = topic.survey_questions.create(:text => "Do you care about #{topic.name}?", :index => 3)

    responses.each do |r|
        verb1 = r[:text] == "Yes" ? "hate" : "don't hate"
        verb2 = r[:text] == "Yes" ? "care" : "don't care"
        actual_response1 = r.clone
        actual_response2 = r.clone
        actual_response1[:summary_text] = "I #{verb1} #{topic.name}."
        actual_response2[:summary_text] = "I #{verb2} about #{topic.name}."
        survey_question1.survey_responses.create(actual_response1)
        survey_question2.survey_responses.create(actual_response2)
    end
end

#More complicated responses
responses = [
    {
        :text => "Education in the US is the best",
        :summary_text => "I believe that education in the US is the best.",
        :index => 2
    },
    {
        :text => "Need to fund education less",
        :summary_text => "I believe that we need to fund education less.",
        :index => 1
    },
    {
        :text => "Need more focus on STEM",
        :summary_text => "I believe that there needs to be more focus on STEM.",
        :index => 0
    },
    {
        :text => "Too many college grads, need to raise tuition fee",
        :summary_text => "I believe that there are too many college gradudates, therefore, we need to raise the tuition fees.",
        :index => 3
    }
]

education = Topic.find_by_name("Education")
survey_question = education.survey_questions.create(:text => "What's your view on US higher education?", :index => 2)
responses.each do |r|
    survey_question.survey_responses.create(r)
end

############################################################
# Users <-> survey responses through user survey responses
############################################################


ben = User.find_by_email("ben@bitdiddle.com")
response = Topic.find_by_name("Climate").survey_questions.find_by_index(1).survey_responses.find_by_index(0)
UserSurveyResponse.create(:user => ben, :survey_response => response)

nick = User.find_by_email("generic@email.com")
response = Topic.find_by_name("Philosophy").survey_questions.find_by_index(1).survey_responses.find_by_index(1)
UserSurveyResponse.create(:user => nick, :survey_response => response)

bob = User.find_by_email("bob@schmitt.com")
response = Topic.find_by_name("LGBT Rights").survey_questions.find_by_index(1).survey_responses.find_by_index(0)
UserSurveyResponse.create(:user => bob, :survey_response => response)

wenson = User.find_by_email("genericasiankid@gmail.com")
response = Topic.find_by_name("Education").survey_questions.find_by_index(1).survey_responses.find_by_index(1)
UserSurveyResponse.create(:user => wenson, :survey_response => response)

rosenthal = User.find_by_email("rosenthal@policy.com")
response = Topic.find_by_name("Foreign Policy").survey_questions.find_by_index(1).survey_responses.find_by_index(1)
UserSurveyResponse.create(:user => rosenthal, :survey_response => response)

####################################################
# Create new test arenas, conversations, and posts
####################################################

arena = ben.arenas.create :user1 => ben, :user2 => bob
conversation = arena.conversations.create :title => "Why is the US education system terrible?"
conversation.posts.create :text => "It all starts in the home. If the parents don't care, no one will.", :author => ben
conversation.posts.create :text => "No, it's actually because the unions have too much power.", :author => bob
conversation.posts.create :text => "You, sir, are an idiot. This is really why the education system sucks. Because people like you go on and on about unions and never do anything to address the real problems at hand. Damnit Bob, get it together.", :author => ben

arena = ben.arenas.create :user1 => ben, :user2 => wenson
conversation = arena.conversations.create :title => "What is our role in mitigating climate change?"
Timecop.freeze 10.years.ago
conversation.posts.create :text => "I believe everyone should go back to living in caves.", :author => ben
conversation.posts.create :text => "No you.", :author => wenson
Timecop.return
Timecop.freeze 10.days.ago
conversation = arena.conversations.create :title => "Is technology to blame for the housing crisis in SF?"
conversation.posts.create :text => "What housing crisis?", :author => wenson
Timecop.return

arena = ben.arenas.create :user1 => ben, :user2 => rosenthal
conversation = arena.conversations.create :title => "This conversation should be blank!"
