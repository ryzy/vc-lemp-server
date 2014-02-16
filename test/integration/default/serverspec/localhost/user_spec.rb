require 'serverspec'

describe "User tuning" do
  describe file('/etc/profile.d/ps.sh') do
    it { should be_file }
    it { should contain('PS1') }
    it { should contain('PS2') }
  end
end
