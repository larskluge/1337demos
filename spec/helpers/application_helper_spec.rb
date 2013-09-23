require 'spec_helper'

describe ApplicationHelper do

  describe '#render_nickname' do

    it 'returns a string thats html safe' do
      expect(render_nickname('lars')).to be_html_safe
    end

    it 'renders plain names' do
      expect(render_nickname('lars')).to eq('<span class="c7">lars</span>')
    end

    it 'renders my name' do
      input = '^7soh^8#^9die^1.^9viper'
      output = '<span class="c7"></span><span class="c7">soh</span><span class="c8">#</span><span class="c9">die</span><span class="c1">.</span><span class="c9">viper</span>'

      expect(render_nickname(input)).to eq(output)
    end

    it 'renders a html conflicting name' do
      expect(render_nickname('<acc/RiFo')).to eq('<span class="c7">&lt;acc/RiFo</span>')
    end

  end

end

