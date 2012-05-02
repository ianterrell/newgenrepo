module OmniAuth
  module Strategies
    class Password
      include OmniAuth::Strategy

      def request_phase
        # noop
      end

      def callback_phase
        return fail!(:invalid_credentials) unless user.try(:authenticate, params[:password])
        super
      end

      def user
        
          @user ||= V1::User.where(:username => params[:username]).first
        
      end

      # Since credentials can come in as a JSON body, we'll use ActionDispatch's parsed parameters.
      def params
        request.env["action_dispatch.request.request_parameters"]
      end

      uid do
        user.password_digest
      end

    end
  end
end
