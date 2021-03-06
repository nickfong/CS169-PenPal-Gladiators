conversation = angular.module("Conversation", ["SharedServices"])

conversation.controller("ConversationController", ["$scope", "$stateParams", "API", "TimeUtil", "AppState", "$rootScope", "ConversationService", "ConversationData", ($scope, $stateParams, API, TimeUtil, AppState, $rootScope, ConversationService, ConversationData) ->
    # Constants
    POST_SUBMISSION_TIMEOUT_PERIOD_MS = 5000
    CONVERSATION_POLL_PERIOD = 10 # seconds
    READ_POSTS = 1
    EDIT_OR_ADD_POST = 2
    EDIT_SUMMARY = 3
    EDIT_RESOLUTION = 4
    EDIT_POST_PLACEHOLDER_TEXT = ""
    NEW_POST_PLACEHOLDER_TEXT = "Write a new post here and submit when you are finished."
    EDIT_SUMMARY_PLACEHOLDER_TEXT = "Summarize your opponent's viewpoint and click Submit when you are finished. If your opponent accepts your summary, it will become a post."
    BEGIN_RESOLUTION_PLACEHOLDER_TEXT = "Be the first to write a statement of resolution between you and your opponent!"
    EDIT_RESOLUTION_PLACEHOLDER_TEXT = "Help edit the final statement of resolution between you and your opponent."
    # State variables
    conversationId = parseInt($stateParams["id"])
    postSubmissionInProgress = false
    conversation = {}
    postsById = {}
    currentPostEditId = null
    postSubmissionTimer = null
    lastUpdateTime = 0
    isEditingTitle = false
    conversationPageState = READ_POSTS
    previousPostContainerOffset = 0
    username = AppState.user.username
    # Scope methods and models
    $scope.editPostText = ""
    $scope.postSubmitError = ""
    $scope.title = -> if "title" of conversation then conversation.title else ""
    $scope.editTitleClicked = ->
        title = document.getElementById("title-text")
        if title
            title.setAttribute("contentEditable", true)
            title.focus()
            isEditingTitle = true
    $scope.titleTextLostFocus = -> $scope.finishEditingTitle(true)
    $scope.finishEditingTitle = (updateTitle) ->
        if not isEditingTitle then return
        title = document.getElementById("title-text")
        if !title then return
        title.setAttribute("contentEditable", false)
        if updateTitle and title.textContent != "" and title.textContent != conversation.title
            API.editTitleByConversationId(conversationId, title.textContent).success (response) ->
                updateConversationData(false)
                $rootScope.$broadcast("reloadSidebarArenas")
            isEditingTitle = false
            title.blur()
        else
            title.textContent = conversation.title

    $scope.timeElapsedMessage = (timestamp) -> TimeUtil.timeIntervalAsString(TimeUtil.timeSince1970InSeconds() - TimeUtil.timeFromTimestampInSeconds(timestamp)) + " ago"
    $scope.shouldHidePostEditor = -> conversationPageState is READ_POSTS
    $scope.postLengthClass = -> if conversationPageState is READ_POSTS then "posts-full-length" else "posts-shortened"
    $scope.postContentClass = (id) ->
        if postsById[id].type is "summary"
            return "post-content-summary"
        if postsById[id].type is "resolution"
            return "post-content-resolution"
        return ""
    $scope.authorClass = (id) ->
        if $scope.authorDisplayNameForPost(id) == username then "self-post" else "other-post"
    $scope.addPostClicked = ->
        savePostInProgress()
        $scope.postSubmitError = ""
        $scope.editPostText = ConversationService.getAddPostText(conversationId)
        currentPostEditId = null
        expandEditorViewForState(EDIT_OR_ADD_POST)

    $scope.shouldDisplayEmptyConversationsMessage = -> !$scope.posts or $scope.posts.length == 0
    $scope.cancelPostClicked = -> closeTextEditor()
    $scope.escapeTextEditor = -> closeTextEditor()
    $scope.authorDisplayNameForPost = (id) ->
        if postsById[id].type is "resolution"
            return "You and #{conversation.opponent.username}"
        return postsById[id].author.username
    $scope.shouldDisableSubmitPost = ->
        if postSubmissionInProgress or $scope.editPostText == ""
            return true
        if conversationPageState is EDIT_OR_ADD_POST and currentPostEditId != null
            return $scope.editPostText == postsById[currentPostEditId].text
        if conversationPageState is EDIT_SUMMARY and conversation.pendingSummaries
            return $scope.editPostText == conversation.pendingSummaries.opposing
        if conversationPageState is EDIT_RESOLUTION
            return !conversation.resolution or $scope.editPostText == conversation.resolution.text
        return false

    $scope.shouldDisableEditor = -> postSubmissionInProgress
    $scope.submitPostClicked = ->
        $scope.postSubmitError = ""
        postSubmissionInProgress = true
        if conversationPageState is EDIT_SUMMARY
            ConversationService.updateSummaryText(conversationId, "")
            API.editSummaryByConversationId(conversationId, $scope.editPostText).success (response) -> handlePostEditResponse(response, false)
        else if conversationPageState is EDIT_RESOLUTION
            ConversationService.updateResolutionText(conversationId, "")
            API.editResolutionByConversationId(conversationId, $scope.editPostText).success (response) -> handlePostEditResponse(response, false)
        else if currentPostEditId is null
            ConversationService.updateAddPostText(conversationId, "")
            API.createPostByConversationId(conversationId, $scope.editPostText).success (response) -> handlePostEditResponse(response, true)
        else
            API.editPostById(currentPostEditId, $scope.editPostText).success (response) -> handlePostEditResponse(response, false)
        postSubmissionTimer = setTimeout(->
            $scope.postSubmitError = "Post submission failed. Please try again later."
            postSubmissionInProgress = false
            $scope.$apply()
        , POST_SUBMISSION_TIMEOUT_PERIOD_MS)

    $scope.shouldDisplayPostEdit = (id) -> postsById[id].author.id == AppState.user.id and postsById[id].type is "post"
    $scope.editPostClicked = (id) ->
        savePostInProgress()
        currentPostEditId = id
        $scope.editPostText = postsById[id].text
        expandEditorViewForState(EDIT_OR_ADD_POST)

    $scope.shouldDisableAddPost = -> conversationPageState is EDIT_OR_ADD_POST
    $scope.shouldHideSummary = -> conversationPageState isnt EDIT_SUMMARY
    $scope.postEditorWidthClass = -> if conversationPageState isnt EDIT_SUMMARY then "post-editor-full" else "post-editor-half"
    $scope.shouldDisableProposeSummary = -> conversationPageState is EDIT_SUMMARY
    $scope.proposeSummaryClicked = ->
        savePostInProgress()
        $scope.editPostText = if conversation.pendingSummaries && conversation.pendingSummaries.opposing != "" then conversation.pendingSummaries.opposing else ConversationService.getSummaryText(conversationId)
        expandEditorViewForState(EDIT_SUMMARY)

    $scope.ownPendingSummaryText = -> if conversation.pendingSummaries then conversation.pendingSummaries.own else ""
    $scope.ownPendingSummaryExists = -> $scope.ownPendingSummaryText() != ""
    $scope.opponentDisplayName = -> if conversation.opponent then conversation.opponent.username else ""
    $scope.approveSummaryClicked = ->
        API.approveSummaryByConversationId(conversation.id).success (response) ->
            updateConversationData(true)
            conversationPageState = READ_POSTS

    $scope.approveResolutionClicked = ->
        API.approveResolutionByConversationId(conversation.id).success (response) ->
            updateConversationData(true)
            conversationPageState = READ_POSTS

    $scope.editorPlaceholderText = ->
        if conversationPageState is EDIT_OR_ADD_POST
            return if currentPostEditId is null then NEW_POST_PLACEHOLDER_TEXT else EDIT_POST_PLACEHOLDER_TEXT
        if conversationPageState is EDIT_SUMMARY
            return EDIT_SUMMARY_PLACEHOLDER_TEXT
        if conversationPageState is EDIT_RESOLUTION
            return if !conversation.resolution or conversation.resolution.state is "unstarted" then BEGIN_RESOLUTION_PLACEHOLDER_TEXT else EDIT_RESOLUTION_PLACEHOLDER_TEXT
        return ""

    $scope.showLastEditedMessage = -> conversationPageState is EDIT_RESOLUTION
    $scope.lastEditedMessage = ->
        if !conversation.resolution or conversation.resolution.state is "unstarted" then return ""
        timeElapsed = $scope.timeElapsedMessage(conversation.resolution.updated_time)
        latestAuthorName = if conversation.resolution.updated_by_id is conversation.self.id then "you" else conversation.opponent.username
        return "Last edited by #{latestAuthorName} #{timeElapsed.toLowerCase()}"
    $scope.shouldDisableEditResolution = -> conversationPageState is EDIT_RESOLUTION
    $scope.shouldDisableApproveResolution = -> !conversation.resolution or
        conversation.resolution.updated_by_id is AppState.user.id or
        conversation.resolution.state != "in_progress" or
        conversation.resolution.text != $scope.editPostText

    $scope.showApproveResolution = -> conversationPageState is EDIT_RESOLUTION
    $scope.editResolutionClicked = ->
        savePostInProgress()
        $scope.editPostText = if conversation.resolution && conversation.resolution.text != "" then conversation.resolution.text else ConversationService.getResolutionText(conversationId)
        expandEditorViewForState(EDIT_RESOLUTION)

    savePostInProgress = () ->
        if conversationPageState == EDIT_OR_ADD_POST && currentPostEditId == null
            # User was writing a new post
            ConversationService.updateAddPostText(conversationId, $scope.editPostText)
        else if conversationPageState == EDIT_SUMMARY
            # User was writing a summary
            ConversationService.updateSummaryText(conversationId, $scope.editPostText)
        else if conversationPageState == EDIT_RESOLUTION
            # User was writing the resolution
            ConversationService.updateResolutionText(conversationId, $scope.editPostText)

    closeTextEditor = () ->
        savePostInProgress()
        conversationPageState = READ_POSTS

    expandEditorViewForState = (state) ->
        if conversationPageState is READ_POSTS and state isnt READ_POSTS
            postsContainer = document.getElementById("posts-container")
            if postsContainer
                previousPostContainerOffset = postsContainer.scrollTop + postsContainer.clientHeight
                setTimeout -> postsContainer.scrollTop = previousPostContainerOffset - postsContainer.clientHeight
            dispatchFocusTextarea()
        conversationPageState = state

    dispatchScrollElementToBottom = (elementId) ->
        setTimeout ->
            postsContainer = document.getElementById(elementId)
            postsContainer.scrollTop = postsContainer.scrollHeight if postsContainer

    handlePostEditResponse = (response, scrollToEnd) ->
        clearTimeout(postSubmissionTimer) if postSubmissionTimer
        postSubmissionInProgress = false
        unless "error" of response
            if conversationPageState isnt EDIT_SUMMARY and conversationPageState isnt EDIT_RESOLUTION
                $scope.editPostText = ""
                conversationPageState = READ_POSTS
        currentPostEditId = null
        updateConversationData(scrollToEnd)

    dispatchFocusTextarea = ->
        setTimeout ->
            textareas = document.getElementsByTagName("textarea")
            textareas[0].focus() if textareas.length > 0

    updateConversationData = (scrollToEnd) ->
        API.requestConversationById(conversationId).success (response) ->
            parseConversation(response, scrollToEnd)

    shouldPollConversationData = -> TimeUtil.timeSince1970InSeconds() - lastUpdateTime > CONVERSATION_POLL_PERIOD
    conversationPollingProcess = setInterval( ->
        updateConversationData(false) if shouldPollConversationData()
    , CONVERSATION_POLL_PERIOD * 1000)

    $rootScope.$on "conversationPageWillLoad", (scope, args) ->
        if conversationId isnt args.conversationId then clearInterval conversationPollingProcess
    $rootScope.$on "$locationChangeStart", (event, next, current) ->
        savePostInProgress()

    parseConversation = (response, scrollToEnd) ->
        conversation.id = response.id
        if not isEditingTitle then conversation.title = response.title
        # The "own" summary is the summary of the user's own viewpoint, written by the opposing gladiator.
        # The "opposing" summary is the summary of the opposing viewpoint, written by the user.
        conversation.pendingSummaries = { own: "", opposing: "" }
        conversation.opponent = null
        conversation.resolution = response.resolution
        $scope.posts = if "posts" of response then response.posts.reverse() else []
        for post in response.posts
            post.type = post.post_type
            delete post["post_type"]
            postsById[post.id] = post
        if response.summaries[0].author.id == AppState.user.id
            selfIndex = 0
        else if response.summaries[1].author.id == AppState.user.id
            selfIndex = 1
        conversation.pendingSummaries.own = response.summaries[1 - selfIndex].text
        conversation.pendingSummaries.opposing = response.summaries[selfIndex].text
        conversation.opponent = response.summaries[1 - selfIndex].author
        conversation.self = response.summaries[selfIndex].author
        dispatchScrollElementToBottom("posts-container") if scrollToEnd
        lastUpdateTime = TimeUtil.timeSince1970InSeconds()

    parseConversation(ConversationData.data, true)
])

conversation.service("ConversationService", () ->
    conversationTexts = {}
    getConversationText = (conversationId) ->
        if conversationId of conversationTexts
            return conversationTexts[conversationId]
        else
            c = {addPostText: "", summaryText: "", resolutionText: ""}
            conversationTexts[conversationId] = c
            return c
    # getter and setter for posts in progress
    this.updateAddPostText = (conversationId, text) ->
        getConversationText(conversationId).addPostText = text
    this.updateSummaryText = (conversationId, text) ->
        getConversationText(conversationId).summaryText = text
    this.updateResolutionText = (conversationId, text) ->
        getConversationText(conversationId).resolutionText = text
    this.getAddPostText = (conversationId) ->
        return getConversationText(conversationId).addPostText
    this.getSummaryText = (conversationId) ->
        return getConversationText(conversationId).summaryText
    this.getResolutionText = (conversationId) ->
        return getConversationText(conversationId).resolutionText
    this.hasUnsavedProgress = (conversationId) ->
        c = getConversationText(conversationId)
        return (c.addPostText != "" or c.summaryText != "" or c.resolutionText != "")
    return
)
