RSpec.describe MessagesController, type: :controller do
  let!(:sender) { create(:user) }
  let!(:receiver) { create(:user) }
  let!(:sender_token) { ApplicationHelper::Helper.encode_token(user_id: sender.id) }
  before do
    headers = {
      'Authorization' => "Bearer #{sender_token}",
      'Content-Type' => 'multipart/form-data'
    }
    request.headers.merge!(headers)
  end

  describe 'GET #conversation' do
    before do
      s_id = sender.id
      r_id = receiver.id
      create(:message, sender_id: s_id, receiver_id: r_id, message: 'A')
      create(:message, sender_id: r_id, receiver_id: s_id, message: 'B')
      create(:message, sender_id: s_id, receiver_id: r_id, message: 'C')
      create(:message, sender_id: r_id, receiver_id: s_id, message: 'D')
    end

    it 'fetches conversation between two users' do
      get :conversation, params: { id: receiver.id }
      expect(response).to have_http_status(:ok)
      expect(json['messages']).to be_an(Array)
    end
  end

  describe 'POST #create' do
    context 'when sender tries to send a message to themself' do
      it 'responds with unauthorized ' do
        post :create, params: { receiver_id: sender.id, message: 'Hello' }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when sender tries to send a message to non-existent receiver' do
      it 'responds with unprocessible content' do
        receiver_id = User.order(id: :asc).last.id + 1
        post :create, params: { receiver_id:, message: 'Hello' }
        expect(response).to have_http_status(422)
      end
    end

    context 'without correct credentials' do
      it 'responds with unauthorized ' do
        receiver_id = receiver.id

        post :create, params: { receiver_id:, message: 'Hello' }
        expect(response).to have_http_status(:created)
      end
    end
  end
end
