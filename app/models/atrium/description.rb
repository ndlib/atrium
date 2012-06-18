require 'sanitize'
class Atrium::Description < ActiveRecord::Base
  self.table_name = 'atrium_descriptions'

  belongs_to :showcase, :class_name => 'Atrium::Showcase', :foreign_key => 'atrium_showcase_id'
  has_one :summary, :class_name => 'Atrium::Essay',  :conditions => "\"atrium_essays\".content_type = \"summary\"", :foreign_key => 'atrium_description_id', :dependent => :destroy
  has_one :essay,   :class_name => 'Atrium::Essay',  :conditions => "\"atrium_essays\".content_type = \"essay\"", :foreign_key => 'atrium_description_id', :dependent => :destroy

  validates_presence_of :atrium_showcase_id

  accepts_nested_attributes_for :essay,   :allow_destroy => true
  accepts_nested_attributes_for :summary, :allow_destroy => true

  #after_save  :update_solr unless ENV['DO_NOT_INDEX'] || RAILS_ENV == "development" || RAILS_ENV == "staging"
  #after_destroy :remove_from_solr unless RAILS_ENV == "development" || RAILS_ENV == "staging"

  def self.get_description_from_solr_id(solr_id)
    #atrium_description=Atrium::Description.find(solr_id.split('_').last)
    atrium_description=Atrium::Description.find_by_description_solr_id(solr_id.to_s)
    logger.debug("$$$$$desc: #{atrium_description.inspect}")
    if atrium_description
      atrium_showcase=Atrium::Showcase.find(atrium_description.atrium_showcase_id)
      return atrium_description , atrium_showcase
    else
      return []
    end
  end

  def pretty_title
    title.blank? ? "Description #{id}" : title
  end

  def get_essay
    essay.blank? ? "" : essay.content
  end

  def get_summary
    essay.blank? ? "" : summary.content
  end

  def generate_solr_id
    "atrium_description_#{id}"
  end

  def get_atrium_showcase_id
    "atrium_showcase_#{id}"
  end

  def as_solr
    doc= {
      :active_fedora_model_s          => "Description",
      :page_display_s                 => (page_display unless page_display.blank?),
      :id                             => generate_solr_id,
      :format                         => "Description",
      :title_t                        => pretty_title,
      :title_s                        => pretty_title,
      :summary_t                      => (summary_text unless summary.blank?),
      :summary_s                      => (summary_text unless summary.blank?),
      :description_content_t          => (essay.content unless essay.blank?),
      :description_content_s          => (essay.content unless essay.blank?),
      :description_content_no_html_t  => (essay_text unless essay.blank?),
      :atrium_showcase_id_t           => get_atrium_showcase_id,
      :atrium_showcase_id_display     => get_atrium_showcase_id
    }.reject{|key, value| value.blank?}
    puts "Doc: #{doc.inspect}"
    return doc
  end

  def summary_text
    ::Sanitize.clean(summary.content).squish unless summary.blank?
  end

  def essay_text
    ::Sanitize.clean(essay.content).squish unless essay.blank?
  end

  def to_solr
    #puts "Into to Solr"
    Blacklight.solr.add as_solr
  end

  def update_solr
    if (description_solr_id.blank?)
      to_solr
      Blacklight.solr.commit
    end
  end

  def show_on_this_page?
    page_display.nil? || page_display == "newpage"
  end

  def blank?
    title.blank? && essay.blank?
  end



  private

  def remove_from_solr
    if(description_solr_id.blank?)
      Blacklight.solr.delete_by_id solr_id
      Blacklight.solr.commit
    end
  end

end
