# encoding: utf-8
#!ruby -Ku
require 'kconv'

# matches = LIKE
class Product < ActiveRecord::Base


  def self.search(search)


    search ||= ""
    keyword_arrays = search.gsub(/　/," ").split()
    for f in 0..(keyword_arrays.length-1) do
     k = keyword_arrays[f].split("")

     for i in 0..(k.length-1) do
      if k[i] =~ /[^\w]/ then
       k[i] = NKF.nkf('-w16xm0', k[i]).inspect.delete("\"")
      end
     end
    keyword_arrays[f] = k.join
    end


          where_clause = "(' ' || tag ) GLOB ?"


      if keyword_arrays.length >= 2  then
 

         where_clause_or = "(' ' || tag ) GLOB ? OR (' ' || tag ) GLOB ?"
         where_clause_and = "(' ' || tag ) GLOB ? AND (' ' || tag ) GLOB ?"

         products_sel = [where_clause_or, "* #{keyword_arrays[0]} *","* #{keyword_arrays[1]} *"]
   
         products_sel_and = [where_clause_and, "* #{keyword_arrays[0]} *","* #{keyword_arrays[1]} *"]


      search_A =  Product.where([where_clause, "* #{keyword_arrays[0]} *"]).count    

    for f in 1..(Futatsume.count) do
      search_word = Futatsume.where(:id => "#{f}").pluck(:name).join 
      search_A_and_B = Product.where([where_clause_and, "* #{keyword_arrays[0]} *","* #{search_word} *"]).count
      if search_A_and_B > (search_A*0.01) then
        search_B = Product.where([where_clause, "* #{search_word} *"]).count
        Futatsume.find("#{f}").update_attribute(:value,search_A_and_B.to_f/search_A.to_f)
      end
    end

      else
          where_clause_or = "(' ' || tag ) GLOB ?"
         where_clause_and = "(' ' || tag ) GLOB ?" 


    products_sel = [where_clause_or, "* #{keyword_arrays[0]} *"]
   
    products_sel_and = [where_clause_and, "* #{keyword_arrays[0]} *"]

      end  
   

#   for i in 1...keyword_arrays.length
#      seminars_sel = seminars_sel.or(concat.matches("\%#{keyword_arrays[i]}\%"))
#      seminars_sel_and = seminars_sel_and.and(concat.matches("\%#{keyword_arrays[i]}\%")) 
#   end



    logger.debug("SQL: #{Product.where(products_sel).to_sql}")
    logger.debug("SQL: #{Product.where(products_sel_and).to_sql}")

    return Product.where(products_sel).count, Product.where(products_sel_and).count
    
  end
end
