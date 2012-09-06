shared_examples "query_param_mixin" do
  it { should be_accessible :saved_search_id }
  it { should_not be_accessible :filter_query_params }
  context "#saved_search_id=" do
    before(:each) do
      Atrium.saved_search_class = 'Object'
    end
    after(:each) do
      Atrium.saved_search_class = nil
    end
    Given(:saved_search_id) { 1 }
    Given(:filter_query_params) { {f: [1,2,3], q: ['a','b'] }}
    Given(:saved_search) { mock(query_params: filter_query_params) }
    Then { subject.should respond_to(:humanized_scope) }

    context 'save_search_id is not present' do
      Given(:saved_search_id) { nil }
      When { subject.filter_query_params = filter_query_params }
      Then {
        lambda {
          subject.saved_search_id = nil
        }.should_not change(subject, :filter_query_params)
      }
    end
    context 'saved search is found' do
      When {
        Atrium.saved_search_class.
        should_receive(:find).
        with(saved_search_id).
        and_return(saved_search)
      }
      Then('#filter_query_params is set') {
        subject.filter_query_params.should == {}
        subject.saved_search_id.should == nil

        subject.saved_search_id = saved_search_id

        subject.saved_search_id.should == saved_search_id
        subject.filter_query_params.should == filter_query_params
      }
    end
    context 'saved search is not found' do
      When {
        Atrium.saved_search_class.
        should_receive(:find).
        with(saved_search_id).
        and_raise(ActiveRecord::RecordNotFound)
      }
      Then('#filter_query_params remains empty') {
        subject.filter_query_params.should == {}
        subject.saved_search_id.should == nil

        subject.saved_search_id = saved_search_id

        subject.filter_query_params.should == {}
        subject.saved_search_id.should == nil
      }
    end
  end
end
