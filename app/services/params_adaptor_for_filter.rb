class ParamsAdaptorForFilter < Delegator
  def initialize(obj)
    super             # pass obj to Delegator constructor, required
    @_sd_obj = obj    # store obj for future use
  end

  def __getobj__
    @_sd_obj          # return object we are delegating to, required
  end

  def __setobj__(obj)
    @_sd_obj = obj    # change delegation object, a feature we're providing
  end

  def filter_query_params
    @_sd_obj
  end
end
