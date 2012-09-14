# TODO: Move to generator
module NavigationHelper

  # Standard display of a facet value in a list. Used in both _facets sidebar
  # partial and catalog/facet expanded list. Will output facet value name as
  # a link to add that to your restrictions, with count in parens.
  # first arg item is a facet value item from rsolr-ext.
  # options consist of:
  # :suppress_link => true # do not make it a link, used for an already selected value for instance
  def get_browse_facet_path(facet_solr_field, value, browse_facets, exhibit_number, exhibit_id, opts={})
    p = HashWithIndifferentAccess.new
    p.merge!(:f=>params[:f].dup) if params[:f]
    p.merge!(:id=>exhibit_id)
    p = remove_related_facet_params(facet_solr_field, p, browse_facets, exhibit_number)
    p = add_browse_facet_params(facet_solr_field,value,p)
    exhibit_path(p.merge!({:class=>"browse_facet_select"}))
  end

  def get_selected_browse_facet_path(facet_solr_field, value, browse_facets, exhibit_number, exhibit_id, opts={})
    value = [value] unless value.is_a? Array
    p = HashWithIndifferentAccess.new
    p.merge!(:f=>params[:f].dup) if params[:f]
    p = remove_related_facet_params(facet_solr_field, p, browse_facets, exhibit_number)
    p.merge!(:id=>exhibit_id)
    # params[:action] == "edit" ? edit_atrium_collection_path(p) : atrium_collection_path(p)
    exhibit_path(p)
  end

  def add_browse_facet_params(field, value, p=HashWithIndifferentAccess.new)
    p[:f]||={}
    p[:f][field] ||= []
    p[:f][field].push(value)
    p
  end

  #Remove current selected facet plus any child facets selected
  def remove_related_facet_params(solr_facet_field, p, browse_facets, exhibit_number)
    if params[:exhibit_number] && params[:exhibit_number].to_i != exhibit_number.to_i
      p.delete(:f) if p[:f]
    elsif browse_facets.include?(solr_facet_field)
      #iterate through browseable facets from current on down
      index = browse_facets.index(solr_facet_field)
      if p[:f]
        browse_facets.slice(index, browse_facets.length - index).each do |f|
          p[:f].delete(f)
        end
      end
    end
    p
  end

  def get_selected_browse_facets(browse_facets)
    selected = {}
    if params[:f]
      browse_facets.each do |facet|
        selected.merge!({facet.to_sym=>params[:f][facet].first}) if params[:f][facet]
      end
    end
    selected
  end

end
