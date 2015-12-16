require 'spec_helper'
describe 'grub2' do

  context 'with defaults for all parameters' do
    it { should contain_class('grub2') }
  end
end
