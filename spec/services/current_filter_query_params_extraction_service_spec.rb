require_relative '../spec_helper'

describe CurrentFilterQueryParamsExtractionService do
  Given(:extractor) {
    lambda {|arg|
      {
        q:'english',
        fq:["{!raw f=format}Book"],
        meaningless: true
      }
    }
  }
  Given(:object_with_params) {
    Object.new.tap {|this|
      def this.params
        {q:'english',f:{"format"=>["Book"]}}
      end
    }
  }
  Given(:extract_service) {
    CurrentFilterQueryParamsExtractionService.new(
      extractor,
      [object_with_params],
      [:params]
    )
  }

  Then do
    extract_service.filter_query_params.should == {
      fq: ["{!raw f=format}Book"],
      q: "english"
    }
  end
end
