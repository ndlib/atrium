module Atrium
  class Essay < ActiveRecord::Base
    belongs_to(
        :description,
        :class_name => 'Atrium::Description',
        :foreign_key => 'atrium_description_id'
    )

    validates_presence_of :atrium_description_id

    attr_accessible(
        :content_type,
        :content ,
        :atrium_description_id
    )

    def blank?
      content.blank?
    end
  end
end
