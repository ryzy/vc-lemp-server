require 'spec_helper'

describe "The system" do
  
  # yum repos
  ['epel','remi','remi-php55','nginx'].each do |repo|
    describe yumrepo(repo) do
      it { should exist }
    end
  end
  
  # swap
  describe command('cat /proc/swaps | wc -l') do
    it { should return_exit_status 0 }
    # /proc/swaps shows 1st line with headlines, so we can assume that if we have >1 line, there's some swap enabled
    its(:stdout) { should_not match /0/ }
    its(:stdout) { should_not match /1/ }
  end
  
  # check if packages are installed
  ['git','htop','man','npm'].each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
  
  # Network check: do we have internet connection?
  describe host('google.com') do
    it { should be_resolvable }
  end
end
