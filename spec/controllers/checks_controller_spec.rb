require 'spec_helper'

describe ChecksController do

  describe '#fail' do

    it 'throws an exception' do
      expect {
        get :fail
      }.to raise_error(/You asked for it/)
    end

  end

end

