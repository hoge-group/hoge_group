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

      if keyword_arrays.length >= 2  then
 

         where_clause_or = "(',' || tag || ',' || tag1 || ',' || tag2 || ',' || tag3 || ',' || tag4 || ',' || tag5 || ',' || tag6 || ',' || tag7 || ',' || tag8 || ',' || tag9) LIKE ? OR (',' || tag || ',' || tag1 || ',' || tag2 || ',' || tag3 || ',' || tag4 || ',' || tag5 || ',' || tag6 || ',' || tag7 || ',' || tag8 || ',' || tag9) LIKE ?"
         where_clause_and = "(',' || tag || ',' || tag1 || ',' || tag2 || ',' || tag3 || ',' || tag4 || ',' || tag5 || ',' || tag6 || ',' || tag7 || ',' || tag8 || ',' || tag9) LIKE ? AND (',' || tag || ',' || tag1 || ',' || tag2 || ',' || tag3 || ',' || tag4 || ',' || tag5 || ',' || tag6 || ',' || tag7 || ',' || tag8 || ',' || tag9) LIKE ?"

         products_sel = [where_clause_or, "%,#{keyword_arrays[0]},%","%,#{keyword_arrays[1]},%"]
   
         products_sel_and = [where_clause_and, "%,#{keyword_arrays[0]},%","%,#{keyword_arrays[1]},%"]


      else
          where_clause_or = "(',' || tag || ',' || tag1 || ',' || tag2 || ',' || tag3 || ',' || tag4 || ',' || tag5 || ',' || tag6 || ',' || tag7 || ',' || tag8 || ',' || tag9) LIKE ?"
         where_clause_and = "(',' || tag || ',' || tag1 || ',' || tag2 || ',' || tag3 || ',' || tag4 || ',' || tag5 || ',' || tag6 || ',' || tag7 || ',' || tag8 || ',' || tag9) LIKE ?" 


    products_sel = [where_clause_or, "%,#{keyword_arrays[0]},%"]
   
    products_sel_and = [where_clause_and, "%,#{keyword_arrays[0]},%"]

      end  
   

#   for i in 1...keyword_arrays.length
#      seminars_sel = seminars_sel.or(concat.matches("\%#{keyword_arrays[i]}\%"))
#      seminars_sel_and = seminars_sel_and.and(concat.matches("\%#{keyword_arrays[i]}\%"))
 
#   end



    logger.debug("SQL: #{Product.where(products_sel).to_sql}")
    logger.debug("SQL: #{Product.where(products_sel_and).to_sql}")

    return Product.where(products_sel), Product.where(products_sel_and)
    
  end
end
