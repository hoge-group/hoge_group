# encoding: utf-8
#!ruby -Ku
require 'kconv'

# matches = LIKE
class Product < ActiveRecord::Base


  def self.search(search)
    
    products_sel_and1 = nil
    products_sel_and2 = nil
    products_sel_and3 = nil
    products_sel_and4 = nil
    products_sel_and5 = nil
    products_sel_and6 = nil
    products_sel_and7 = nil
    products_sel_and8 = nil
    products_sel_and9 = nil
    products_sel_and10 = nil   
    tag = Array.new(10).map{ Array.new(10)}  

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
    
    products = Product.arel_table[:tag]
    columns = Product.column_names
    products_sel = products.matches("#{keyword_arrays[0]}")
    products_sel_and = products.matches("#{keyword_arrays[0]}")
    
    for i in 1...10
    
      eval("products_sel_and#{i} = Product.arel_table[columns[i]].matches('#{keyword_arrays[0]}')")


#    eval("products_sel_and#{i} = Product.arel_table[columns[i]].matches("#{keyword_arrays[0]}")")
 
# = Product.arel_table[str].matches("#{keyword_arrays[0]}")

    end
    
    for j in 1...10
      for i in 0...keyword_arrays.length
        products_sel = products_sel.or(Product.arel_table[columns[j]].matches(keyword_arrays[i]))
#        products_sel_and[j] = products_sel_and[j].or(products.matches(keyword_arrays[i]))
      eval("products_sel_and#{j} = products_sel_and#{j}.or(Product.arel_table[columns[j]].matches(keyword_arrays[i]))")
      end
      #products_sel_and = products_sel_and.and(eval("products_sel_and#{j}")) 
    end
    
    for j in 1...10
     for i in j+1...10
      tag[j][i] = eval("products_sel_and#{j}").and(eval("products_sel_and#{i}"))
     end
    end

    for j in 1...10
     for i in j+1...10
     tag[1][2] = tag[1][2].or(tag[j][i])
     end
    end
    products_sel_and = tag[1][2]

    logger.debug("SQL: #{Product.where(products_sel).to_sql}")
    logger.debug("SQL: #{Product.where(products_sel_and).to_sql}")

    return Product.where(products_sel), Product.where(products_sel_and)
    
  end
end
