require_relative '../spec_helper'

describe ParamsAdaptorForFilter do
  Given(:params) { {f: 'Hello', w: 'World'} }
  Given(:adaptor) { ParamsAdaptorForFilter.new(params) }

  Then { adaptor.filter_query_params.should == params}
end
