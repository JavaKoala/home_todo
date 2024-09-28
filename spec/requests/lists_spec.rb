require 'rails_helper'

RSpec.describe 'Lists' do
  describe 'GET /index' do
    it 'returns http success' do
      get '/'
      expect(response).to have_http_status(:success)
    end

    it 'renders when the list does not exist' do
      get '/lists?list_id=1'
      expect(response).to render_template(:index)
    end
  end

  describe 'POST /create' do
    it 'creates a new list' do
      post '/lists', params: { list: { name: 'My List' } }
      expect(response).to redirect_to('/lists')
    end

    it 'does not create a list without a name' do
      post '/lists', params: { list: { name: '' } }
      expect(response).to render_template(:index)
    end
  end

  describe 'DELETE /destroy' do
    it 'deletes a list' do
      list = List.create(name: 'My List')

      expect do
        delete "/lists/#{list.id}"
      end.to change(List, :count).by(-1)
    end

    it 'redirects to lists' do
      list = List.create(name: 'My List')
      delete "/lists/#{list.id}"
      expect(response).to redirect_to('/lists')
    end

    it 'redirects when the list does not exist' do
      delete '/lists/1'
      expect(response).to redirect_to('/lists')
    end
  end
end
