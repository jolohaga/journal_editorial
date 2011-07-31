require 'extensions/active_record'
class ActiveRecord::Base
  extend Journal::Extensions::ActiveRecord
end

require 'extensions/string'
include Journal::Extensions::String