# The purpose of this class is to consolodate the :q and :fq params for querying
# SOLR.
class CurrentFilterQueryParamsExtractionService
  # @param [lambda] the function that will convert :f params to :fq
  # @param [Array] an array of receiver objects that will interact with that may
  #         have methods which return a hash with keys :f and :q
  # @param [Array] an array of symbols representing messages to send to each of
  #         the receiver objects; These messages should return a hash
  def initialize(
      solr_fq_extractor,
      objects_to_merge_solr_params = [],
      method_names_with_query_params = []
    )

    raise(
      RuntimeError,
      "Expected :solr_fq_extractor for #{self.class} to respond to #call"
    ) unless solr_fq_extractor.respond_to?(:call)

    raise(
      RuntimeError,
      "Expected :objects_to_merge_solr_params for #{self.class}" <<
      " to respond to #each"
    ) unless objects_to_merge_solr_params.respond_to?(:each)

    raise(
      RuntimeError,
      "Expected :method_names_with_query_params for #{self.class}" <<
      " to respond to #each"
    ) unless method_names_with_query_params.respond_to?(:each)

    @solr_fq_extractor = solr_fq_extractor
    @objects_to_merge_solr_params = objects_to_merge_solr_params
    @method_names_with_query_params = method_names_with_query_params
  end

  def filter_query_params
    f_queries = []
    queries = []

    @objects_to_merge_solr_params.each do |object|
      @method_names_with_query_params.each do |method_name|
        collect_solr_params_from(object, method_name) do |q,fq|
          queries << q if q
          f_queries << fq if fq
        end
      end
    end

    {
      fq: f_queries.uniq.flatten,
      q: queries.uniq.flatten.join(" AND ")
    }
  end

  protected

  def collect_solr_params_from(object, method_name)
    begin
      return false unless object.public_send(method_name).present?
    rescue NoMethodError
      # Either an undefined method; or we are trying to call a private method
      return false
    end

    query_params = object.public_send(method_name)

    return false unless query_params.respond_to?(:fetch)

    solrized_hash = @solr_fq_extractor.call(query_params)

    q_value = nil
    begin
      q_value = solrized_hash.fetch(:q)
    rescue NoMethodError, KeyError
    end

    fq_value = nil
    begin
      fq_value = solrized_hash.fetch(:fq)
    rescue NoMethodError, KeyError
    end

    if q_value || fq_value
      yield(q_value, fq_value)
      return q_value, fq_value
    else
      return nil
    end
  end
end
