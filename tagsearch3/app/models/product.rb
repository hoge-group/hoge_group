# encoding: utf-8
#!ruby -Ku
require 'kconv'

# matches = LIKE
class Product < ActiveRecord::Base


  def self.search(search)
    
    #変数定義
    kinji_value = Array.new{Array.new(2)}
    sorted = [[nil,nil]] 

    #検索タグをUTF-16に変換する
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
     
     #タグ件数を求めるのに使用するSQL文を格納
     where_clause = "(tag) GLOB ?"

　　#検索タグが空の処理
      if keyword_arrays.length != 1  then
         sorted = [nil,nil]
         return nil, nil, sorted
      end 
　　#ORとANDのSQL文を定義
         where_clause_or = "'vocaloid_tags'.'tag' GLOB ? OR 'vocaloid_tags'.'tag' GLOB ?"
         where_clause_and = "SELECT id FROM vocaloid_tags WHERE 'vocaloid_tags'.'tag' GLOB ? INTERSECT SELECT id FROM 'vocaloid_tags' WHERE 'vocaloid_tags'.'tag' GLOB ?"

   #検索タグAのタグ数
      search_A =  VocaloidTag.where([where_clause, "#{keyword_arrays[0]}"]).count 
      i = 0

           #頻出タグを読み出し、類似度を計算する
           for f in 1..(Futatsume.count) do
            search_word_utf8 = Futatsume.where(:id => "#{f}").pluck(:name).join 
            search_word = NKF.nkf('-w16xm0', search_word_utf8).inspect.delete("\"").downcase 
            search_A_and_B = VocaloidTag.find_by_sql([where_clause_and, "#{keyword_arrays[0]}","#{search_word}"]).count
             if search_A_and_B > (search_A*0.001) then
              search_B = VocaloidTag.where([where_clause, "#{search_word}"]).count
# A*B^2
              kinji_value[i] = ["#{search_word_utf8}",(search_A_and_B.to_f/search_A.to_f*(search_A_and_B.to_f/search_B.to_f)**2).round(5),search_B] #^2係数
# jaccard係数
#              kinji_value[i] = ["#{search_word_utf8}",(search_A_and_B.to_f/(search_A.to_f+search_B.to_f-search_A_and_B.to_f)).round(5),search_B] 
              i = i+1

             end
           end

        #類似度でソートする        
        if kinji_value != nil 
          sorted = kinji_value.sort {|a, b| b[1] <=> a[1] } 
        end


       products_sel = [where_clause,"#{keyword_arrays[0]}"]
   
       products_sel_and = [where_clause,"#{keyword_arrays[0]}"]

   



    logger.debug("SQL: #{IdTag.where(products_sel).to_sql}")
    logger.debug("SQL: #{IdTag.where(products_sel_and).to_sql}")

    #検索タグ数、検索タグ名、タグのソートを渡す
    return search_A, search_tag, sorted 
    
  end
end
