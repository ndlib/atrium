class ParamsAdaptorForFilter < Delegator
  def initialize(obj)
    super
    @_sd_obj = obj
  end

  def __getobj__
    @_sd_obj
  end

  def __setobj__(obj)
    @_sd_obj = obj
  end

  def filter_query_params
    @_sd_obj
  end
end
