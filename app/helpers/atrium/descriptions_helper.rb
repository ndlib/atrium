module Atrium::DescriptionsHelper

  def get_description_for_showcase(showcase)
    solr_desc_arr=[]
    showcase.descriptions.each do |desc|
      solr_desc_arr<< desc.description_solr_id unless desc.description_solr_id.blank?
    end
    @description_hash={}
    unless solr_desc_arr.empty?
      p = params.dup
      params.delete :f
      params.delete :q
      desc_response, desc_documents = get_solr_response_for_field_values("id",solr_desc_arr.uniq)
      desc_documents.each do |doc|
        @description_hash[doc["id"]]= doc["description_content_s"].blank? ? "" : doc["description_content_s"].first
      end
      params.merge!(:f=>p[:f])
      params.merge!(:q=>p[:q])
    end
    return @description_hash
  end

end