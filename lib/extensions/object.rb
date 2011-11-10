module Journal
   module Extensions
      module Object
         def is_numeric?
            !!Float(self) rescue false
         end
      end
   end
end