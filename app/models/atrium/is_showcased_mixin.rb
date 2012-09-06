require 'active_support/concern'
module Atrium::IsShowcasedMixin
  extend ActiveSupport::Concern

  included do
    has_many(
      :showcases,
      class_name: 'Atrium::Showcase',
      as: :showcases,
      dependent: :destroy
    )
    accepts_nested_attributes_for :showcases

    def showcase_order
      showcases.each_with_object({}) { |showcase, object|
        object[showcase[:id]] = showcase.sequence
      }
    end

    def showcase_order=(showcase_order = {})
      showcase_order.each_pair do |showcase_id, sequence|
        begin
          showcases.find(showcase_id).update_attributes!(sequence: sequence)
        rescue ActiveRecord::RecordNotFound
        end
      end
    end
    attr_accessible(
      :showcase_order,
      :showcases_attributes
    )

  end
end
