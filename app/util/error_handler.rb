module ErrorHandler
    ERROR = {
        :incorrect_credentials => "incorrect credentials",
        :expired_token => "access token expired",
        :invalid_token => "invalid access token",
        :invalid_email => "invalid email",
        :invalid_password => "invalid password",
        :user_exists => "user exists",
        :resource_not_found => "resource not found"
    }

    ERROR_CODE = {
        :incorrect_credentials => 401,
        :expired_token => 401,
        :invalid_token => 401,
        :invalid_email => 400,
        :invalid_password => 400,
        :user_exists => 400,
        :resource_not_found => 404
    }

    def render_error(error, args = {})
        render :json => { :error => ERROR[error] }.merge(args), :status => ERROR_CODE[error]
    end

end
