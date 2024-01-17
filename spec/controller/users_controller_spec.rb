RSpec.describe UsersController, type: :controller do
  let!(:user) { create(:user, email: 'prajwal@gmail.com', password: 'password') }
  let!(:token) { ApplicationHelper::Helper.encode_token(user_id: user.id) }
  let(:form_headers) do
    {
      'Authorization' => "Bearer #{token}",
      'Content-Type' => 'multipart/form-data'
    }
  end
  let(:json_headers) do
    {
      'Authorization' => "Bearer #{token}",
      'Content-Type' => 'application/json'
    }
  end

  describe 'GET #me' do
    context 'without auth token' do
      it 'returns with a status of unauthorized' do
        get :me
        expect(response).to have_http_status(:unauthorized)
      end
    end
    context 'with auth token' do
      it 'returns the auth user with status of ok' do
        request.headers.merge!(json_headers)
        get :me
        expect(response).to have_http_status(:ok)
        expect(json['id']).to eql(user.id)
      end
    end
  end

  describe 'GET #list' do
    context 'without auth token' do
      it 'returns with a status of unauthorized' do
        get :list
        expect(response).to have_http_status(:unauthorized)
      end
    end
    context 'with auth token' do
      it 'returns a list of user with status of ok' do
        request.headers.merge!(json_headers)
        get :list
        expect(response).to have_http_status(:ok)
        expect(json['users']).to be_an(Array)
      end
    end
  end

  describe 'POST #create' do
    before do
      request.headers.merge!(form_headers)
    end
    context 'create a new user with in-valid credentials' do
      it 'returns the created user of user with status of created' do
        params = {
          'email' => 'prajwalgautam@gmail.com',
          'password' => 'password'
        }
        post(:create, params:)
        expect(response).to have_http_status(422)
      end
    end
    context 'create a new user with valid credentials' do
      it 'returns the created user of user with status of created' do
        params = {
          'email' => 'prajwalgautam@gmail.com',
          'name' => 'Prajwal Gautam',
          'password' => 'password'
        }
        post(:create, params:)
        expect(response).to have_http_status(:created)
        expect(json['user']['email']).to eql('prajwalgautam@gmail.com')
      end
    end
  end

  describe 'GET #show' do
    context 'without auth token' do
      it 'returns with a status of unauthorized' do
        get :show, params: { 'id' => user.id }
        expect(response).to have_http_status(:unauthorized)
      end
    end
    context 'with auth token' do
      it 'returns a user with status of ok' do
        request.headers.merge!(json_headers)
        get :show, params: { 'id' => user.id }
        expect(response).to have_http_status(:ok)
        expect(json['user']['id']).to eql(user.id)
      end
    end
  end

  describe 'Patch /users/:id/change-password' do
    before do
      request.headers.merge!(json_headers)
    end
    context 'Change password of a user with incorrect credentials' do
      it 'respond with 401' do
        params = {
          'old_password' => 'wrong_password',
          'new_password' => 'new_password',
          'id' => user.id
        }
        patch(:change_password, params:)
        expect(response).to have_http_status(:unauthorized)
      end
    end
    context 'Change password of a user with correct credentials' do
      it 'successfully changes the user\'s password and responds with ok' do
        params = {
          'old_password' => 'password',
          'new_password' => 'new_password',
          'id' => user.id
        }
        patch(:change_password, params:)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
