require 'rails_helper'

RSpec.describe 'Todos' do
  let(:list) { List.create(name: 'My List') }

  describe 'POST /create' do
    context 'when the create is successful' do
      it 'creates a new todo' do
        expect do
          post '/todos', params: { todo: { description: 'My Todo', due: Time.zone.now, list_id: list.id } }
        end.to change(Todo, :count).by(1)
      end

      it 'redirects to list' do
        post '/todos', params: { todo: { description: 'My Todo', due: Time.zone.now, list_id: list.id } }

        expect(response).to redirect_to("/lists?list_id=#{list.id}")
      end

      it 'does not add flash' do
        post '/todos', params: { todo: { description: 'My Todo', due: Time.zone.now, list_id: list.id } }

        expect(flash).to be_empty
      end
    end

    context 'when the create is unsuccessful' do
      it 'does not create a new todo' do
        expect do
          post '/todos', params: { todo: { description: '', due: Time.zone.now, list_id: list.id } }
        end.not_to change(Todo, :count)
      end

      it 'redirects to list' do
        post '/todos', params: { todo: { description: '', due: Time.zone.now, list_id: list.id } }

        expect(response).to redirect_to("/lists?list_id=#{list.id}")
      end

      it 'adds flash message' do
        post '/todos', params: { todo: { description: '', due: Time.zone.now, list_id: list.id } }

        expect(flash.first).to eq(['alert', "Description can't be blank"])
      end
    end
  end

  describe 'PATCH /update' do
    let(:todo) { Todo.create(description: 'My Todo', due: Time.zone.now, list_id: list.id) }

    context 'when the update is successful' do
      it 'redirects to list' do
        patch "/todos/#{todo.id}", params: {
          todo: { description: 'My Updated Todo', due: Time.zone.now, done: true }
        }

        expect(response).to redirect_to("/lists?list_id=#{list.id}")
      end

      it 'does not add flash' do
        patch "/todos/#{todo.id}", params: {
          todo: { description: 'My Updated Todo', due: Time.zone.now, done: true }
        }

        expect(flash).to be_empty
      end
    end

    context 'when the update is unsuccessful' do
      it 'redirects to list' do
        patch "/todos/#{todo.id}", params: {
          todo: { description: '', due: Time.zone.now, done: false }
        }

        expect(response).to redirect_to("/lists?list_id=#{list.id}")
      end

      it 'adds flash with error' do
        patch "/todos/#{todo.id}", params: {
          todo: { description: '', due: Time.zone.now, done: false }
        }

        expect(flash.first).to eq(['alert', "Description can't be blank"])
      end
    end

    context 'when the todo does not exit' do
      it 'redirects to list' do
        patch "/todos/#{todo.id + 1}", params: {
          todo: { description: 'My Updated Todo', due: Time.zone.now, done: true }
        }

        expect(response).to redirect_to('/lists')
      end

      it 'adds flash with error' do
        patch "/todos/#{todo.id + 1}", params: {
          todo: { description: 'My Updated Todo', due: Time.zone.now, done: false }
        }

        expect(flash.first).to eq(['alert', "Can't find Todo"])
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when the list has done todos' do
      it 'deletes all done todos' do
        Todo.create(description: 'My Todo', due: Time.zone.now, list_id: list.id, done: true)

        expect do
          delete "/todos/#{list.id}"
        end.to change(Todo, :count).by(-1)
      end

      it 'redirects to list' do
        Todo.create(description: 'My Todo', due: Time.zone.now, list_id: list.id, done: true)

        delete "/todos/#{list.id}"

        expect(response).to redirect_to("/lists?list_id=#{list.id}")
      end
    end

    context 'when the list has no done todos' do
      it 'does not delete any todo' do
        Todo.create(description: 'My Todo', due: Time.zone.now, list_id: list.id, done: false)

        expect do
          delete "/todos/#{list.id}"
        end.not_to change(Todo, :count)
      end

      it 'redirects to list' do
        Todo.create(description: 'My Todo', due: Time.zone.now, list_id: list.id, done: false)

        delete "/todos/#{list.id}"
        expect(response).to redirect_to("/lists?list_id=#{list.id}")
      end
    end
  end
end
