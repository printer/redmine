require 'redmine/access_control'

module Redmine
  module AccessControl
    class <<self
      def delete(name)
        @permissions.delete( permission(name) )
      end
    end
  end
end