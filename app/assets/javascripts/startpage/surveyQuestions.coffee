# Assumes that questions and responses come sorted from the controller

surveyQuestions = angular.module("SurveyQuestions", ["StartPageServices"])

surveyQuestions.config(["$routeProvider", ($routeProvider) ->
    $routeProvider.when("/questions/:id", {
        templateUrl: "/assets/survey_questions.html",
        controller: "SurveyQuestionsController"
    })
    .when("/questions/:id/edit", {
        templateUrl: "/assets/survey_questions_edit.html",
        controller: "SurveyQuestionsController"
    })
]).controller("SurveyQuestionsController", ["$scope", "$http", "$location", "$routeParams", "SharedRequests", "StartPageData", ($scope, $http, $location, $routeParams, SharedRequests, StartPageData) ->
    $scope.allTopics = StartPageData.getAllTopics()                 # all the topics
    $scope.selectedTopicIds = StartPageData.getSelectedTopicIds()   # the ids of the topics the user selected
    $scope.currentTopicId = $routeParams.id
    $scope.currentTopic = $scope.allTopics[$scope.currentTopicId].name # the topic we're doing now

    $scope.questions = StartPageData.getTopicQuestions($scope.currentTopicId)
    $scope.questionCheckModel = StartPageData.getResponseIdsByTopicId($scope.currentTopicId)
    $scope.numQuestions = if $scope.questions.length == 0 then -1 else $scope.questions.length  # the number of questions for this topic

    currentState = StartPageData.getCurrentState()

    # Regex pattern to match states of the form "questions-X" where X is a 0-index
    statePattern = /^questions-(\d+)$/
    # Helper function to determine if current state refers to this page
    isCurrentState = ->
        match = currentState.match(statePattern)
        if match != null
            i = parseInt(match[1])
            if $scope.selectedTopicIds.indexOf($scope.currentTopicId) == i
                return true
        return false
    # Get the description for the page, which changes depending on whether the user is visiting
    # a page with ALL questions answered already
    $scope.pageDescription = ->
        numQuestions = $scope.questions.length
        if isCurrentState()
            return "Answer the following #{numQuestions} questions to proceed"
        else
            return "Edit responses and press Next to continue"

    # Call this when a response is selected to toggle -- only allows one
    # response to be selected at once
    $scope.handleResponseSelected = (question, selectedResponse) ->
        for response in question.survey_responses
            $scope.questionCheckModel[response.id] = false
        $scope.questionCheckModel[selectedResponse.id] = true
        StartPageData.addResponseIdsByTopicId($scope.currentTopicId, $scope.questionCheckModel)

    # Get the number of questions with no responses selected yet
    $scope.numUnansweredQuestions = ->
        questionsLeft = $scope.questions.length
        for question in $scope.questions
            for response in question.survey_responses
                if $scope.questionCheckModel[response.id]
                    questionsLeft -= 1
                    break
        return questionsLeft

    $scope.disableNextButton = ->
        return $scope.numUnansweredQuestions() > 0

    # Get the text that should be displayed on the Next button
    $scope.nextButtonValue = ->
        questionsLeft = $scope.numUnansweredQuestions()
        if questionsLeft == 0
            return "Next"
        else
            return "#{questionsLeft} Unanswered Question#{if $scope.numUnansweredQuestions() == 1 then '' else 's'}"

    # Helper function to advance to the summary page
    $scope.handleAdvanceToSummary = ->
        StartPageData.updateState("summary")
        tmp = {}
        for topicId in $scope.selectedTopicIds
            tmp[topicId] = StartPageData.getResponseIdsByTopicId(topicId)
        StartPageData.clearResponseIdsByTopics()
        StartPageData.addResponseIdsByTopicId(topicId, checkModel) for topicId, checkModel of tmp
        $location.path("summary")

    # Helper function to advance to the question for the next topic
    handleAdvanceToQuestions = (topicId) ->
        if isCurrentState()
            match = currentState.match(statePattern)
            i = parseInt(match[1])
            StartPageData.updateState("questions-#{i+1}")
        $location.path("questions/#{topicId}")

    # Call either handleAdvanceToQuestions or handleAdvanceToSummary depending on
    # if there are more topics to answer questions for
    $scope.handleAdvance = ->
        nextIndex = $scope.selectedTopicIds.indexOf($scope.currentTopicId) + 1
        if nextIndex < $scope.selectedTopicIds.length
            nextTopicId = $scope.selectedTopicIds[nextIndex]
            handleAdvanceToQuestions(nextTopicId)
        else
            $scope.handleAdvanceToSummary()

    # Helper function to move back to the topic selection page
    handleBackToTopics = ->
        $location.path("topics")

    # Helper function to move back to another question page
    handleBackToQuestions = (topicId) ->
        $location.path("questions/#{topicId}")

    # Call either handleBackToTopics or handleBackToQuestions depending on
    # if the previous page is the topic selection page or not
    $scope.handleBack = ->
        prevIndex = $scope.selectedTopicIds.indexOf($scope.currentTopicId) - 1
        if prevIndex >= 0
            prevTopicId = $scope.selectedTopicIds[prevIndex]
            handleBackToQuestions(prevTopicId)
        else
            handleBackToTopics()



    # Asynchronously load the list of questions for a topic
    load_questions = (topicId) ->
        if $scope.questions.length == 0
            SharedRequests.requestQuestionsByTopic(topicId).success( (allQuestions) ->
                $scope.questions = []
                allQuestions = allQuestions.sort((u, v) -> u.index - v.index)
                $scope.questions = allQuestions
                StartPageData.addTopicQuestions($scope.currentTopicId, $scope.questions)
                $scope.numQuestions = $scope.questions.length
            )
        $scope.currentTopic = $scope.allTopics[topicId].name
        if Object.keys($scope.questionCheckModel).length == 0
            for question in $scope.questions
                for response in question.survey_responses
                    $scope.questionCheckModel[response.id] = false


    load_questions($scope.currentTopicId)
])