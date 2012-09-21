shared_examples "query_param_mixin" do
  it { should be_accessible :include_search_id }
  it { should be_accessible :exclude_search_id }
  it { should be_accessible :remove_filter_query_params }
  it { should_not be_accessible :filter_query_params }
  it { should be_accessible :remove_exclude_query_params }
  it { should_not be_accessible :exclude_query_params }

  context "#find_saved_search_and_format_to_query" do
    before(:each) do
      Atrium.saved_search_class = 'Object'
    end
    after(:each) do
      Atrium.saved_search_class = nil
    end
    Given(:search_id) { 1 }
    Given(:filter_query_params) { {f: [1,2,3], q: ['a','b'] }}
    Given(:saved_search) { mock(query_params: filter_query_params) }

    context 'search_id is not present' do
      Given(:saved_search_id) { nil }
      Then  { subject.find_saved_search_and_format_to_query(saved_search_id).should == nil }
    end
    context 'saved search is found' do
      When {
        Atrium.saved_search_class.
            should_receive(:find).
            with(search_id).
            and_return(saved_search)
      }
      Then('#return filter query param from saved search') {
        subject.find_saved_search_and_format_to_query(search_id).should == filter_query_params
      }
    end
    context 'saved search is not found' do
      When {
        Atrium.saved_search_class.
            should_receive(:find).
            with(search_id).
            and_raise(ActiveRecord::RecordNotFound)
      }
      Then('#filter_query_params remains empty') {
        subject.find_saved_search_and_format_to_query(search_id).should == {}
      }
    end
  end

  context 'include_search_id=' do

    context 'include_search_id is not set' do
      Given(:search_id) { nil }
      When {  subject.filter_query_params = {}}
      Then('#filter_query_params is not changed') {
        lambda {
          subject.include_search_id = search_id
        }.should_not change(subject, :filter_query_params)
      }
    end

    context 'include_search_id is set' do
      Given(:search_id) { 1 }
      Given(:filter_query_params) { {f: [1,2,3], q: ['a','b'] }}
      Given {
        subject.
            should_receive(:find_saved_search_and_format_to_query).
            with(search_id).
            and_return(filter_query_params)
      }
      When { subject.filter_query_params = {} }
      Then('#filter_query_params is set to query params from saved search') {
        subject.filter_query_params.should == {}
        subject.include_search_id.should == nil

        subject.include_search_id = search_id

        subject.filter_query_params.should == filter_query_params
        subject.include_search_id.should == nil

      }
    end
  end

  context 'exclude_search_id=' do

    context 'exclude_search_id is not set' do
      Given(:search_id) { nil }
      When {  subject.exclude_query_params = {}}
      Then('#exclude_query_params is not changed') {
        lambda {
          subject.exclude_search_id = search_id
        }.should_not change(subject, :exclude_query_params)
      }
    end

    context 'exclude_search_id is set' do
      Given(:search_id) { 1 }
      Given(:exclude_query_params) { {f: [1,2,3], q: ['a','b'] }}
      Given {
        subject.
            should_receive(:find_saved_search_and_format_to_query).
            with(search_id).
            and_return(exclude_query_params)
      }
      When { subject.exclude_query_params = {} }
      Then('#filter_query_params is set to query params from saved search') {
        subject.exclude_query_params.should == {}
        subject.exclude_search_id.should == nil

        subject.exclude_search_id = search_id

        subject.exclude_query_params.should == {:exclude=>exclude_query_params}
        subject.exclude_search_id.should == nil

      }
    end
  end

  context "#remove_filter_query_params=" do
    Given(:filter_query_params) { {f: [1,2,3], q: ['a','b'] }}
    context 'remove_filter_query_params is set to nil' do
      Given(:remove_filter_query_params) { nil }
      When { subject.filter_query_params = filter_query_params }
      Then{
        lambda {
        subject.remove_filter_query_params = remove_filter_query_params
      }.should_not change(subject, :filter_query_params)
      }
    end
    context 'remove_filter_query_params checkbox is checked' do
      Given(:remove_filter_query_params) { 1 }
      When { subject.filter_query_params = filter_query_params }
      Then{
        lambda {
          subject.remove_filter_query_params = remove_filter_query_params
        }.should change(subject, :filter_query_params)
      }
    end
    context 'remove_filter_query_params checkbox is not checked' do
      Given(:remove_filter_query_params) { 0 }
      When { subject.filter_query_params = filter_query_params }
      Then{
        lambda {
          subject.remove_filter_query_params = remove_filter_query_params
        }.should_not change(subject, :filter_query_params)
      }
    end
  end

  context "#remove_exclude_query_params==" do
    Given(:exclude_query_params) { {f: [1,2,3], q: ['a','b'] }}
    context 'remove_exclude_query_params is set to nil' do
      Given(:remove_exclude_query_params) { nil }
      When { subject.exclude_query_params = exclude_query_params }
      Then{
        lambda {
          subject.remove_exclude_query_params = remove_exclude_query_params
        }.should_not change(subject, :exclude_query_params)
      }
    end
    context 'remove_filter_query_params checkbox is checked' do
      Given(:remove_exclude_query_params) { 1 }
      When { subject.exclude_query_params = exclude_query_params }
      Then{
        lambda {
          subject.remove_exclude_query_params = remove_exclude_query_params
        }.should change(subject, :exclude_query_params)
      }
    end
    context 'remove_exclude_query_params checkbox not checked' do
      Given(:remove_exclude_query_params) { 0 }
      When { subject.exclude_query_params = exclude_query_params }
      Then{
        lambda {
          subject.remove_exclude_query_params = remove_exclude_query_params
        }.should_not change(subject, :exclude_query_params)
      }
    end
  end
end
