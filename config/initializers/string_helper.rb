#coding utf-8
class String
     def downcase
       self.mb_chars.downcase.to_s
     end
     def downcase!
       self.replace downcase
     end
     def upcase
       self.mb_chars.upcase.to_s
     end
     def upcase!
       self.replace upcase
     end
     def capitalize
       self.mb_chars.capitalize.to_s
     end
     def capitalize!
       self.replace capitalize
     end
     def titleize
       self.mb_chars.titleize.to_s
     end
     def titleize!
       self.replace titleize
     end
end
