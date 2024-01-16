RSpec.describe Message, type: :model do
  let(:sender) { User.create(name: 'prajwal', email: 'prajwal@gmail.com', password: 'password') }
  let(:receiver) { User.create(name: 'rohan', email: 'rohan@gmail.com', password: 'password') }

  subject do
    described_class.create(sender_id: sender.id, receiver_id: receiver.id, message: 'Hello Boss')
  end

  describe 'Validation' do
    context 'Presence' do
      it { should validate_presence_of :message }
      it { should belong_to(:sender).class_name('User') }
      it { should belong_to(:receiver).class_name('User') }
    end
  end

  it 'is not valid when sender id equals receiver id' do
    subject.receiver_id = sender.id
    expect do
      subject.save
    end.to raise_error(ArgumentError, 'Sender and Receiver should be different')
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end
end
