RSpec.describe OtpsController, type: :controller do
  let!(:user) { create(:user, email: 'prajwal@gmail.com', password: 'password') }

  describe 'GET OTP and verify user' do
    before do
      get_otp_for_user('prajwal@gmail.com')
    end

    it 'responds with a status of ok' do
      expect(response).to have_http_status(:ok)
    end

    context 'with valid OTP value' do
      it 'responds with unauthorized' do
        # Valid otp is only 6 digits long
        post :verify_otp, params: { 'email' => 'prajwal@gmail.com', 'otp' => '12345688' }
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds with ok' do
        post :verify_otp, params: { 'email' => 'prajwal@gmail.com', 'otp' => @otp_code }
        expect(response).to have_http_status(:ok)
      end
    end

    it 'verifies a user' do
      post :verify_user, params: { 'email' => 'prajwal@gmail.com', 'otp' => @otp_code }
      expect(response).to have_http_status(:ok)
    end
  end

  private

  def get_otp_for_user(email)
    get :send_to_mail, params: { email: }
    @hashed_otp = BCrypt::Password.new(json['otp_entity']['otp'])
    @otp_code = json['otp_code']
  end
end
