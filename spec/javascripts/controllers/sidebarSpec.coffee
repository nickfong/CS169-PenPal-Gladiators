#= require ./spec_helper

describe "SidebarController", ->
    beforeEach inject (AppState) ->
        @http.when("GET", "/api/v1/arenas/1").respond [{
            user1: {id: 1, username: "ben@bitdiddle.com", avatar: "/path/to/ben.png"},
            user2: {id: 3, username: "bob@schmitt.com", avatar: "/path/to/bob.png"},
            conversations: [{
                id: 1,
                title: "Why is the US education system terrible?",
                timestamp: "2015-04-01T18:50:22Z",
                recent_post: {
                    author_id: 1,
                    text: "You, sir, are an idiot. This is really why the education system sucks. Because people like you go on and on about unions and never do anything to address the real problems at hand. Damnit Bob, get it together."
                }
            }]
        }]
        AppState.setUserId(1)
        @http.expectGET("/api/v1/arenas/1")
        @controller("SidebarController", { $scope: @scope })
        @http.flush();

    it "should store the correct arenas", ->
        expect(3 of @scope.conversationsByUserId).toEqual true
        expect(1 of @scope.conversationsByUserId).toEqual false

    it "should store the correct conversations", ->
        conversations = @scope.conversationsByUserId[3]
        expect(conversations.length).toEqual 1
        conversation = conversations[0]
        expect(conversation.title).toEqual "Why is the US education system terrible?"
        expect(conversation.post_preview_text.length).toBeLessThan 150
        expect(conversation.post_preview_text).toMatch /^You said: "You, sir, are an idiot.*\.\.\."$/

    it "should store the correct conversations", ->
        conversations = @scope.conversationsByUserId[3]
        expect(conversations.length).toEqual 1
        conversation = conversations[0]
        expect(conversation.title).toEqual "Why is the US education system terrible?"
        expect(conversation.post_preview_text.length).toBeLessThan 150
        expect(conversation.post_preview_text).toMatch /^You said: "You, sir, are an idiot.*\.\.\."$/

    it "should store the correct list of gladiators and their names", ->
        expect(@scope.gladiatorIds).toEqual [3]
        expect(@scope.gladiatorById[3].username).toEqual "bob@schmitt.com"
        expect(Object.keys @scope.gladiatorById).toEqual ["1", "3"]

    it "should be able to toggle arena states", ->
        expect(3 of @scope.arenaStateByUserId).toEqual true
        expect(@scope.arenaStateByUserId[3]).toEqual false
        @scope.toggleGladiatorPanel(3)
        expect(@scope.arenaStateByUserId[3]).toEqual true
        @scope.toggleGladiatorPanel(3)
        expect(@scope.arenaStateByUserId[3]).toEqual false

    it "should toggle expand and collapse buttons", ->
        expect(@scope.expandButtonClass(3)).toMatch "down"
        @scope.toggleGladiatorPanel(3)
        expect(@scope.expandButtonClass(3)).toMatch "up"
