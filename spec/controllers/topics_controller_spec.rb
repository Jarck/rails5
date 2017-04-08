require 'rails_helper'

RSpec.describe TopicsController, type: :controller  do

  let(:user) { FactoryGirl.create(:user) }
  let(:topic) { FactoryGirl.create(:topic, user: user) }

  describe "GET #index" do
    it 'is have an index action' do
      get :index

      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template('index')
    end
  end

  describe "GET #new" do
    context 'unsign in' do
      it 'is not allow to new without sign in' do
        expect{get :new}.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'sign in' do
      it 'is allow to new with sign in' do
        sign_in user
        get :new

        expect(response).to be_success
      end
    end
  end

  describe "GET #edit" do
    context "unsign in" do
      it 'is not allow to edit without sign in' do
        expect{get :edit, params: {id: topic.id}}.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'sign in' do
      it 'is allow to edit with sign in' do
        sign_in user
        get :edit, params: {id: topic.id}

        expect(response).to be_success
      end
    end
  end

  describe "GET #show" do
    context "unsign in" do
      it 'is allow to show without sign in' do
        get :show, params: {id: topic.id}

        expect(response).to be_success
      end
    end

    context "sign in" do
      it 'is allow to show with sign in' do
        sign_in user
        get :show, params: {id: topic.id}

        expect(response).to be_success
      end
    end
  end

  describe "PATCH #update" do
    let(:valid_topic_attribute) { FactoryGirl.attributes_for(:topic, title: 'test update') }

    context "unsign in" do
      it 'is not allow to update without sign in' do
        expect{ patch :update, params: {id: topic.id, topic: valid_topic_attribute}}.to raise_error(CanCan::AccessDenied)
      end
    end

    context "sign in" do
      it 'is allow to update with sign in' do
        sign_in user

        patch :update, params: {id: topic.id, topic: valid_topic_attribute}
        topic.reload

        expect(topic.title).to eq('test update')
      end
    end
  end

  describe "POST #create" do
    let(:valid_topic_attribute) { FactoryGirl.attributes_for(:topic) }

    context "unsign in" do
      it 'is not allow to create without sign in' do
        expect{ post :create, params: {topic: valid_topic_attribute}}.to raise_error(CanCan::AccessDenied)
      end
    end

    context "sign in" do
      it 'is allow to create with sign in' do
        sign_in user

        expect{ post :create, params: {topic: valid_topic_attribute}}.to change(Topic, :count).by(1)
      end
    end
  end

  describe "DELETE #destroy" do
    context "unsign in" do
      it 'is allow to destroy without sign in' do
        expect{delete :destroy, params: {id: topic.id}}.to raise_error(CanCan::AccessDenied)
      end
    end

    context "sign in" do
      it 'is allow to destroy with sign in' do
        sign_in user
        delete :destroy, params: {id: topic.id}

        expect(response).to redirect_to(topics_path)
      end
    end
  end

end