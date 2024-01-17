RSpec.describe AuthController, type: :controller do
  let!(:user) { create(:user, email: 'prajwal@gmail.com', password: 'password') }
  let!(:otp) { create(:otp, user:) }

  describe 'POST #login' do
    context 'with in-valid credentials' do
      before do
        email = 'prajwal10@gmail.com'
        password = 'password'
        post :login, params: { email:, password: }
      end
      it 'returns with a status of unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with valid credentials' do
      before do
        email = 'prajwal@gmail.com'
        password = 'password'
        post :login, params: { email:, password: }
      end
      it 'returns with a status of accepted' do
        expect(response).to have_http_status(:accepted)
      end
      it 'returns the auth user and a token' do
        token = json['token']
        auth_user = json['user']
        expect(token).to_not be_nil
        expect(auth_user['email']).to eql(user.email)
      end
    end
  end

  describe 'POST #forgot_password' do
    context 'with in-valid credentials' do
      it 'returns with a status of unauthorized' do
        email = 'prajwal@gmail.com'
        new_password = 'password123'
        post :forgot_password, params: { email:, new_password:, otp: '123486' }
        expect(response).to have_http_status(401)
      end
    end
    context 'with valid credentials' do
      it 'returns with a status of ok' do
        email = 'prajwal@gmail.com'
        new_password = 'password123'
        post :forgot_password, params: { email:, new_password:, otp: '123456' }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
