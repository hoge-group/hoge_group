
# encoding: utf-8
#!ruby -Ku
require 'kconv'

# matches = LIKE
class AnimeTag < ActiveRecord::Base

  def self.search(search)
    
    #変数定義
    kinji_value = Array.new{Array.new(2)}
    sorted = [[nil,nil]] 

    search ||= ""
    keyword_arrays = search.gsub(/　/," ").split()
    for f in 0..(keyword_arrays.length-1) do
     k = keyword_arrays[f].split("")
     search_tag = keyword_arrays[0]

     for i in 0..(k.length-1) do
      if k[i] =~ /[^\w]/ then
       k[i] = NKF.nkf('-w16xm0', k[i]).inspect.delete("\"").downcase
      end
     end
    keyword_arrays[f] = k.join
    end
         
     where_clause = "(tag) GLOB ?"


      if keyword_arrays.length != 1  then
         sorted = [nil,nil]
         return nil, nil, sorted
      end 

         where_clause_or = "'anime_tags'.'tag' GLOB ? OR 'anime_tags'.'tag' GLOB ?"
         where_clause_and = "SELECT id FROM anime_tags WHERE 'anime_tags'.'tag' GLOB ? INTERSECT SELECT id FROM 'anime_tags' WHERE 'anime_tags'.'tag' GLOB ?"

  
      search_A =  AnimeTag.where([where_clause, "#{keyword_arrays[0]}"]).count 
      i = 0

           for f in 1..(AnimeWord.count) do
            search_word_utf8 = AnimeWord.where(:id => "#{f}").pluck(:name).join 
            search_word = NKF.nkf('-w16xm0', search_word_utf8).inspect.delete("\"").downcase 
            search_A_and_B = AnimeTag.find_by_sql([where_clause_and, "#{keyword_arrays[0]}","#{search_word}"]).count
             if search_A_and_B > (search_A*0.001) then
              search_B = AnimeTag.where([where_clause, "#{search_word}"]).count
              kinji_value[i] = ["#{search_word_utf8}",(search_A_and_B.to_f/search_A.to_f*(search_A_and_B.to_f/search_B.to_f)**2).round(5),search_B]
              i = i+1
             end
           end

        
        if kinji_value != nil 
          sorted = kinji_value.sort {|a, b| b[1] <=> a[1] } 
        end


       products_sel = [where_clause,"#{keyword_arrays[0]}"]
   
       products_sel_and = [where_clause,"#{keyword_arrays[0]}"]

   



    logger.debug("SQL: #{IdTag.where(products_sel).to_sql}")
    logger.debug("SQL: #{IdTag.where(products_sel_and).to_sql}")

    return search_A, search_tag, sorted 
  end 
end

