require 'spec_helper'

describe Atrium::Showcase do
  Given(:showcase) { Atrium::Showcase.new() }
  it { should have_many :descriptions }
  it { should have_many :facet_selections }
  it { should belong_to :showcases }
  it { should delegate(:collection).to(:showcases) }

  context "#checking parent type" do
    Given(:exhibit) { Atrium::Exhibit.new }
    Given(:collection) { Atrium::Collection.new }
    context 'exhibit showcase' do
      Given(:showcase) { exhibit.showcases.build}
      Then { showcase.for_exhibit?.should == true }
    end
    context 'collection showcase' do
      Given(:showcase) { collection.showcases.build}
      Then { showcase.for_exhibit?.should_not == true }
    end
  end

  context '#parent' do
    Then { showcase.should alias_from(:showcases).to(:parent) }
  end
  context 'with database', database: true do
    describe "#creating showcase without facet selection" do
      it "should allow no facet selections defined" do
        collection = Atrium::Collection.new
        collection.save
        showcase = Atrium::Showcase.new(showcases_id:collection.id, showcases_type:collection.class.name)
        showcase.save!
        showcase.facet_selections.should == []
      end
    end

    describe "#with_selected_facets" do
      before(:each) do
        @collection = Atrium::Collection.new
        @collection.save
        @exhibit = Atrium::Exhibit.new(atrium_collection_id:@collection.id,set_number:1)
        @exhibit.save
        @collection_showcase = Atrium::Showcase.new(showcases_id:@collection.id, showcases_type:@collection.class.name)
        @collection_showcase.save
        @exhibit_showcase = Atrium::Showcase.new(showcases_id:@exhibit.id, showcases_type:@exhibit.class.name)
        @exhibit_showcase.save
      end
      it "should return correct showcase with no facets selected" do
        @showcase2 = Atrium::Showcase.new({showcases_id:@exhibit.id, showcases_type:@exhibit.class.name})
        @showcase2.save!
        @facet_selection2 = @showcase2.facet_selections.create({solr_facet_name:"my_facet2",value:"testing2"})
        Atrium::Showcase.with_selected_facets(@exhibit.id).first.should == @showcase
      end

      it "should return correct showcase with one facet selected" do
        @showcase = Atrium::Showcase.new({showcases_id:@exhibit.id, showcases_type:@exhibit.class.name})
        @showcase.save!
        @facet_selection = @showcase.facet_selections.create({solr_facet_name:"my_facet",value:"testing"})
        @showcase.save!
        Atrium::Showcase.with_selected_facets(@exhibit.id, @exhibit.class.name, {@facet_selection.solr_facet_name=>@facet_selection.value}).first.should == @showcase
      end

      it "should return correct showcase with one facet selected but a showcase exists with same facet plus another" do
        @showcase = Atrium::Showcase.new({showcases_id:@exhibit.id, showcases_type:@exhibit.class.name})
        @showcase.save!
        @facet_selection = @showcase.facet_selections.create({solr_facet_name:"my_facet",value:"testing"})
        @showcase.save!
        @showcase2 = Atrium::Showcase.new({showcases_id:@exhibit.id, showcases_type:@exhibit.class.name})
        @showcase2.save!
        @facet_selection2 = @showcase2.facet_selections.create({solr_facet_name:"my_facet2",value:"testing2"})
        Atrium::Showcase.with_selected_facets(@exhibit.id, @exhibit.class.name, {@facet_selection.solr_facet_name=>@facet_selection.value}).first.should == @showcase
      end

      it "should return correct showcase with two facets selected" do
        @showcase = Atrium::Showcase.new({showcases_id:@exhibit.id, showcases_type:@exhibit.class.name})
        @showcase.save!
        @facet_selection = @showcase.facet_selections.create({solr_facet_name:"my_facet",value:"testing"})
        @facet_selection2 = @showcase.facet_selections.create({solr_facet_name:"my_facet2",value:"testing2"})
        @showcase.save!
        Atrium::Showcase.with_selected_facets(@exhibit.id, @exhibit.class.name, {@facet_selection2.solr_facet_name=>@facet_selection2.value,
                                                                                 @facet_selection.solr_facet_name=>@facet_selection.value}).first.should == @showcase
      end

      it "should return correct showcase with same facet selections but different exhibit" do
        @showcase = Atrium::Showcase.new({showcases_id:@exhibit.id, showcases_type:@exhibit.class.name})
        @showcase.save!
        @facet_selection = @showcase.facet_selections.create({solr_facet_name:"my_facet",value:"testing"})
        @exhibit2 = Atrium::Exhibit.new(atrium_collection_id:@collection.id,set_number:2)
        @exhibit2.save!
        @showcase2 = Atrium::Showcase.new({showcases_id:@exhibit2.id, showcases_type:@exhibit2.class.name})
        @showcase2.save!
        @facet_selection2 = @showcase2.facet_selections.create({solr_facet_name:"my_facet",value:"testing"})
        Atrium::Showcase.with_selected_facets(@exhibit2.id,@exhibit2.class.name, {@facet_selection2.solr_facet_name=>@facet_selection2.value}).first.should == @showcase2
      end
    end
  end
end
