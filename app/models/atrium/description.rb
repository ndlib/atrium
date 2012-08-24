module Atrium
  class Description < ActiveRecord::Base
    belongs_to(
        :showcase,
        :class_name => 'Atrium::Showcase',
        :foreign_key => 'atrium_showcase_id'
    )

    has_one(
        :summary,
        :class_name => 'Atrium::Essay',
        :conditions => "\"atrium_essays\".content_type = \"summary\"",
        :foreign_key => 'atrium_description_id',
        :dependent => :destroy,
        :inverse_of => :description
    )
    accepts_nested_attributes_for :summary, :allow_destroy => true

    def get_summary
      essay.blank? ? "" : summary.content
    end

    has_one(
        :essay,
        :class_name => 'Atrium::Essay',
        :conditions => "\"atrium_essays\".content_type = \"essay\"",
        :foreign_key => 'atrium_description_id',
        :dependent => :destroy,
        :inverse_of => :description
    )
    accepts_nested_attributes_for :essay,   :allow_destroy => true
    def get_essay
      essay.blank? ? "" : essay.content
    end


    validates_presence_of :atrium_showcase_id

    attr_accessible(
        :description_solr_id,
        :page_display,
        :title,
        :atrium_showcase_id,
        :essay_attributes,
        :summary_attributes
    )

    def generate_solr_id
      "atrium_description_#{id}"
    end

    def summary_text
      ::Sanitize.clean(summary.content).squish unless summary.blank?
    end
    private :summary_text

    def essay_text
      ::Sanitize.clean(essay.content).squish unless essay.blank?
    end
    private :essay_text


    def pretty_title
      title.blank? ? "Description #{id}" : title
    end

    def show_on_this_page?
      page_display.nil? || page_display == "samepage"
    end

    def blank?
      title.blank? && essay.blank?
    end
  end
end
