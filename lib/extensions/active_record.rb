module Journal
  module Extensions
    module ActiveRecord
      def or_expand(row,values)
        sql_condition(row,values,' OR ')
      end
      
      def not_and_expand(row,values)
        sql_condition(row,values,' AND ',true)
      end
      
      def sql_condition(row, values, condition, negate = false)
        vals = values.is_a?(Array) ? values : [values]
        if negate
          Array.new(vals.length,"NOT #{row} = ").zip(vals.collect {|v| v.quote}).collect {|a| a.join('')}.join(condition)
        else
          Array.new(vals.length,"#{row} = ").zip(vals.collect {|v| v.quote}).collect {|a| a.join('')}.join(condition)
        end
      end
    end
  end
end