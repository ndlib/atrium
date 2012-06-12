class Atrium::Essay < ActiveRecord::Base
  self.table_name = 'atrium_essays'

  belongs_to :description, :class_name => 'Atrium::Description', :foreign_key => 'atrium_description_id'

  validates_presence_of :atrium_description_id

  def blank?
    content.blank?
  end
end
