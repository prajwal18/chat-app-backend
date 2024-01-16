RSpec.describe Otp, type: :model do
  let(:user) { User.create(name: 'prajwal', email: 'prajwal@gmail.com', password: 'password') }
  let(:otp) { Otp.generate }
  subject do
    described_class.create(user_id: user.id, otp:)
  end

  describe 'Validation' do
    context 'Presence' do
      it { should belong_to(:user).class_name('User') }
      it { should validate_presence_of :otp }
    end
  end
  
  it 'otp should match' do
    expect(BCrypt::Password.new(subject.otp) == otp).to equal(true)
  end
end
