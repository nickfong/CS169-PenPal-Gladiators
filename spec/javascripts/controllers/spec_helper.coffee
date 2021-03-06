#= require startPage
#= require homePage
#= require angular-mocks
#= require angular-route
#= require sinon
#= require jasmine-sinon
beforeEach module("StartPage")
beforeEach module("HomePage")

beforeEach inject (_$httpBackend_, _$compile_, $rootScope, $controller, $location, $injector, $timeout) ->
  @scope = $rootScope.$new()
  @http = _$httpBackend_
  @compile = _$compile_
  @location = $location
  @controller = $controller
  @injector = $injector
  @timeout = $timeout
  @model = (name) =>
    @injector.get(name)
  @eventLoop =
    flush: =>
      @scope.$digest()
  @sandbox = sinon.sandbox.create()

# HACK Terrible workaround assets loading
beforeEach ->
  @http.when("GET", /\/assets\/.*/).respond("<div></div>")

afterEach ->
  @http.resetExpectations()
  @http.verifyNoOutstandingExpectation()
