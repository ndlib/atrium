module Atrium::DescriptionsHelper

  def get_description_for_showcase(showcase)
    solr_desc_arr=[]
    showcase.descriptions.each do |desc|
      solr_desc_arr<< desc.description_solr_id unless desc.description_solr_id.blank?
    end
    @description_hash={}
    logger.debug("Desc Array: #{solr_desc_arr.inspect}")
    unless solr_desc_arr.empty?
      p = params.dup
      params.delete :f
      params.delete :q
      params.delete :page
      desc_response, desc_documents = get_solr_response_for_field_values("id",solr_desc_arr.uniq)
      logger.debug("desc_documents Array: #{desc_documents.inspect}")
      desc_documents.each do |doc|
        @description_hash[doc["id"]]= doc["description_content_s"].blank? ? "" : doc["description_content_s"].first
      end
      params.merge!(:f=>p[:f])
      params.merge!(:q=>p[:q])
      params.merge!(:page=>p[:page])
    end
    return @description_hash
  end

end