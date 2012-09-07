require 'spec_helper'

describe Atrium::DescriptionsController do
  Given(:showcase_id) { '1' }
  Given(:showcase) { mock_model(Atrium::Showcase) }
  before(:each) do
    Atrium::Showcase.should_receive(:find).with(showcase_id).
      and_return(showcase)
    showcase.should_receive(:descriptions).and_return(descriptions)
  end

  context 'collection actions' do
    Given(:descriptions) { [mock_model(Atrium::Description)] }
    When { get :index, showcase_id: showcase_id }
    Then { assigns(:descriptions).should == descriptions }
    Then { assigns(:showcase).should == showcase }
  end

  context 'member actions' do
    Given(:description) { mock_model(Atrium::Description) }
    Given(:descriptions) {
      mock("Showcase descriptions", build: description, find: description)
    }

    describe "Get New"   do
      before(:each) do
        description.should_receive(:build_essay).with(content_type:'essay')
        description.should_receive(:build_summary).with(content_type:'summary')
      end

      it "should assign description" do
        do_new
        assigns(:description).should == description
      end

      it "should render new template" do
        do_new
        response.should render_template("new")
      end
    end

    describe "Post create"   do
      before(:each) do
        description.should_receive(:save!).and_return(true)
      end
      it "should assign description" do
        do_create
        assigns(:description).should == description
      end

      it "should render edit template" do
        do_create
        response.should render_template("edit")
      end
    end

    describe "Get Edit"   do
      before(:each) do
        description.should_receive(:essay).
          and_return(@essay = mock_model(Atrium::Essay))
        description.should_receive(:summary).
          and_return(@summary = mock_model(Atrium::Essay))
      end
      it "should assign description" do
        do_edit
        assigns(:description).should == description
      end

      it "should render edit template" do
        do_edit
        response.should render_template("edit")
      end
    end

    describe "Put Update"   do
      before(:each) do
        description.should_receive(:update_attributes).and_return(true)
      end
      it "should assign description" do
        do_update
        assigns(:description).should == description
      end

      it "should render edit" do
        do_update
        response.should render_template("edit")
      end
    end

    describe "Delete" do
      before(:each) do
        description.should_receive(:pretty_title).and_return("title")
      end
      it "destroy description successfully" do
        delete :destroy,  showcase_id: showcase_id, id: "1"
        flash[:notice].should == "Description title was deleted successfully."
      end

      it "redirects to showcase edit" do
        delete :destroy,  showcase_id: showcase_id, id: "1"
        response.should redirect_to(edit_showcase_path(showcase))
      end
    end

  end

  def do_new
    get :new, showcase_id: showcase_id
  end

  def do_create
    post(
      :create,
      showcase_id: showcase_id,
      description:{title:"new description"}
    )
  end
  def do_edit
    get :edit,showcase_id: showcase_id
  end

  def do_update
    put :update, showcase_id: showcase_id, description: {
      title:"new description", slug:"url_slug"
    }
  end
end
