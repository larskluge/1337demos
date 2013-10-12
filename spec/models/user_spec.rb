require 'spec_helper'

describe User do

  describe '#mail_pass' do

    it 'auto sets mail attribute' do
      mail = 'me@aekym.com'
      user = User.new(:mail_pass => mail)

      expect(user.passphrase).to be_present
      expect(user.mail).to eq(mail)
    end

  end

end

