RSpec.describe User, type: :model do
  let(:password) { 'password' }

  subject do
    described_class.new(name: 'Prajwal Gautam', email: 'prajwal@gmail.com', password:)
  end
  
  describe 'Validation' do
    context 'Presence' do
      it { should validate_presence_of :name }
      it { should validate_presence_of :email }
      it { should validate_presence_of :password }
    end
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end
end