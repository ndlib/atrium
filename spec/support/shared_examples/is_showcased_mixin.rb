shared_examples "is_showcased_mixin" do
  it { should be_accessible :showcase_order }
  it { should accept_nested_attributes_for :showcases }

  context '#showcase_order=' do
    Given(:showcase_1) { FactoryGirl.create(:showcase, showcases: subject) }
    Given(:showcase_2) { FactoryGirl.create(:showcase, showcases: subject) }
    Given(:proposed_order) do
      {
        showcase_1[:id] => 2,
        showcase_2[:id] => 1
      }
    end
    When { subject.update_attributes(showcase_order: proposed_order) }
    Then { subject.reload.showcase_order.should == proposed_order }
  end

end
