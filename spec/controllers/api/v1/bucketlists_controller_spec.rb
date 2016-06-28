require "rails_helper"

RSpec.describe API::V1::BucketlistsController, type: :controller do
  let!(:bucketlist) { create(:bucketlist) }

  describe 'GET #index' do
    before { get :index }

    it "returns a status code 200" do
      expect(response.status).to eq(200)
    end

    it "assigns bucketlists to @bucketlists" do
      expect(assigns(:bucketlists)).to eq(Bucketlist.all)
    end

    context "when query is present" do
      context "when the record exists" do
        it "finds the bucketlist" do
          get :index, q: bucketlist.name
          parsed_response = json(response.body)
          expect(parsed_response.first["name"]).to eq(bucketlist.name)
        end
      end

      context "when the record doesn't exist" do
        before { get :index, q: 'example record' }

        it "returns a status code 404" do
          expect(response.status).to eq(404)
        end

        it 'returns a message' do
          expect(response.body).to eq("Sorry, example record not found.")
        end
      end
    end
  end

  describe 'GET #show' do
    before { get :show, id: bucketlist.id }

    it "returns a status code 200" do
      expect(response.status).to eq(200)
    end

    it "assigns bucketlist to @bucketlist" do
      expect(assigns(:bucketlist)).to eq(bucketlist)
    end

    it "shows a bucketlist" do
      parsed_response = json(response.body)
      expect(parsed_response["name"]).to eq(bucketlist.name)
    end
  end

  describe 'POST #create' do
    let(:bucketlist) { build(:bucketlist) }

    context "when valid request" do
      it "returns a status code 201" do
        post :create, name: bucketlist.name, created_by: bucketlist.created_by
        expect(response.status).to eq(201)
      end

      it "creates a new bucketlist" do
        expect do
          post :create, name: bucketlist.name, created_by: bucketlist.created_by
        end.to change(Bucketlist, :count).by(1)
      end
    end

    context "when invalid request" do
      it "returns a status code 422" do
        post :create, name: nil, created_by: bucketlist.created_by
        expect(response.status).to eq(422)
      end

      it "does not create a new bucketlist" do
        expect do
          post :create, name: nil, created_by: bucketlist.created_by
        end.to change(Bucketlist, :count).by(0)
      end
    end
  end

  describe 'GET #show' do
    it 'retrieves a bucketlist' do
      get :show, id: bucketlist.id
      parsed_response = json(response.body)
      expect(parsed_response["name"]).to eq(bucketlist.name)
      expect(response.status).to eq(200)
    end
  end

  describe 'PUT #update' do
    it 'updates a bucketlist' do
      put :update, id: bucketlist.id, name: 'Mozart'
      updated_bucketlist = Bucketlist.find(bucketlist.id)
      expect(updated_bucketlist.name).to eq('Mozart')
      expect(response.status).to eq(204)
    end
  end

  describe 'DELETE #destroy' do
    let!(:bucketlists) { create_list(:bucketlist, 5) }

    it 'deletes a bucketlist' do
      expect do
        delete :destroy, id: bucketlists.last.id
      end.to change(Bucketlist, :count).by(-1)
      expect(response.status).to eq(204)
    end
  end
end