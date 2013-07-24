module Sinatra
  class Base
    include Rack::Utils

    helpers do

      def viewing_year
        session[:year] = session[:year] || Date.today.year
      end

      alias_method :h, :escape_html

      # Require either advisor or resident, a non-student that is directly
      # involved in the class.
      def require_admin
        unless env['warden'].user.advisor? || env['warden'].user.resident?
          flash.error = "You are not authorized to access that page."
          redirect '/'
        end
      end

      # Public: Basic date formatting for the entire site.
      def longdate(d)
        d.strftime("%b %d")
      end

      def shortdate(d)
        d.strftime("%_m/%e")
      end
    end
  end
end