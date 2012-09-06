class ParamsAdaptorForFilter
  def initialize(params)
    @params = params
  end
  def filter_query_params
    @params
  end
end
