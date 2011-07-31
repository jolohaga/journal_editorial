module Journal
  module Extensions
    module String
      def symbolize
        self.variableize.to_sym
      end
      
      def variableize
        self.downcase.gsub(/ /,'_')
      end
      
      def quote
        "\'#{self}\'"
      end
    end
  end
end