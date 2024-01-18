RSpec.describe UserMailer, type: :mailer do
  describe 'send welcome and otp email' do
    let(:user) { create(:user) }
    let(:sender_email) { 'homework.buddy.fyp.mailer@gmail.com' }

    context 'send welcome email' do
      let(:mail) { described_class.welcome_email(user).deliver_now }

      it 'should send the email' do
        expect { described_class.welcome_email(user).deliver_now }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'renders the subject' do
        expect(mail.subject).to eq('Welcome to My Awesome Site')
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([user.email])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq([sender_email])
      end

      it 'assigns @user.name' do
        binding
        expect(mail.body.encoded).to match(user.name)
      end
    end

    context 'send otp email' do
      let(:otp) {  create(:otp, user:, otp: '777000') }
      let(:mail) { described_class.otp_email(user, '777000', otp.expires_at).deliver_now }

      it 'should send the email' do
        expect { described_class.otp_email(user, '777000', otp.expires_at).deliver_now }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'renders the subject' do
        expect(mail.subject).to eq('Chat App - User verification OTP')
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([user.email])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq([sender_email])
      end

      it 'assigns @user.name' do
        binding
        expect(mail.body.encoded).to match(user.name)
      end

      it 'assigns @otp' do
        binding
        expect(mail.body.encoded).to match('777000')
      end
      it 'assigns @expires_at' do
        binding
        expect(mail.body.encoded).to match(otp.expires_at.to_s)
      end
    end
  end
end
