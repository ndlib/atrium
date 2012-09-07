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
    Given(:description_id) { '2' }
    Given(:description_attributes) { { 'Title' => 'New Title'} }
    Given(:description) { mock_model(Atrium::Description, id: description_id) }
    Given(:descriptions) { mock("Showcase descriptions") }

    describe "GET :new"   do
      before(:each) do
        descriptions.should_receive(:build).with(description_attributes).
          and_return(description)
        description.should_receive(:build_essay).with(content_type:'essay')
        description.should_receive(:build_summary).with(content_type:'summary')
      end

      When {
        get :new, showcase_id: showcase_id,description: description_attributes
      }
      Then { assigns(:description).should == description }
      Then { response.should render_template("new") }
    end

    describe "POST :create"   do
      before(:each) do
        descriptions.should_receive(:build).with(description_attributes).
          and_return(description)
      end
      context 'failure' do
        When {
          description.should_receive(:save!).and_return(false)
        }
        When {
          post(
            :create,
            showcase_id: showcase_id,
            description: description_attributes
          )
        }
        Then { assigns(:description).should == description }
        Then { response.should render_template("new") }
      end
      context 'success' do
        When {
          description.should_receive(:save!).and_return(true)
        }
        When {
          post(
            :create,
            showcase_id: showcase_id,
            description: description_attributes
          )
        }
        Then { assigns(:description).should == description }
        Then {
          response.should(
            redirect_to(edit_showcase_description_path(showcase,description))
          )
        }
      end
    end

    describe "GET :edit"   do
      before(:each) do
        descriptions.should_receive(:find).with(description_id).
          and_return(description)
        description.should_receive(:essay).
          and_return(@essay = mock_model(Atrium::Essay))
        description.should_receive(:summary).
          and_return(@summary = mock_model(Atrium::Essay))
      end
      When{
        get :edit,showcase_id: showcase_id, id: description_id
      }
      Then { assigns(:description).should == description }
      Then { response.should render_template("edit") }
    end

    describe "PUT :update"   do
      before(:each) do
        descriptions.should_receive(:find).with(description_id).
          and_return(description)
      end
      context 'success' do
        When{ description.should_receive(:update_attributes).and_return(true) }
        When {
          put :update, showcase_id: showcase_id, id: description_id,
          description: {
            title:"new description", slug:"url_slug"
          }
        }
        Then { assigns(:description).should == description }
        Then { response.should render_template("edit") }
      end
    end

    describe "Delete" do
      before(:each) do
        descriptions.should_receive(:find).with(description_id).
          and_return(description)
        description.should_receive(:pretty_title).and_return("title")
      end
      When { delete :destroy,  showcase_id: showcase_id, id: description_id }
      Then {
        flash[:notice].should == "Description title was deleted successfully."
      }
      Then { response.should redirect_to(edit_showcase_path(showcase)) }
    end

  end
end
