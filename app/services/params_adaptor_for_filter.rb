class ParamsAdaptorForFilter < DelegateClass(Hash)
  def initialize(params)
    super(params)
  end
  def filter_query_params
    self
  end
end