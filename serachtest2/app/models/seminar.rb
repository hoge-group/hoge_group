# encoding: utf-8

class Seminar < ActiveRecord::Base

    searchable do
        text :summary
    end
end


