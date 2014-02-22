require 'spec_helper'

describe "::ruby tests" do
  
  # check if ruby and gem is available
  ['ruby','gem'].each do |cmd|
    describe command("#{cmd} -v") do
      it { should return_exit_status 0 }
    end
  end
  
  describe command('ruby-build --definitions') do
    it { should return_exit_status 0 }
  end
  
  describe command('chruby-exec --help') do
    it { should return_exit_status 0 }
  end
  
end
