require "spec_helper"
require "serverspec"

repos = [
  { path: "/home/vagrant/demo", branch: "demo" }
]
user = "vagrant"
bundle_bin = "bundle"

case os[:family]
when "openbsd"
  bundle_bin = if os[:release].to_f <= 6.5
                 "bundle25"
               else
                 "bundle26"
               end
end

repos.each do |r|
  describe command("(env && cd #{r[:path]} && #{bundle_bin} exec jekyll --help)") do
    let(:disable_sudo) { true }
    let(:path) { "$PATH:$HOME/bin" }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/^jekyll\s\d+\.\d+\.\d+\s/) }
    its(:stderr) { should eq "" }
  end
  describe command("(cd #{r[:path]} && git branch)") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/^\*\s+#{r[:branch]}/) }
    its(:stderr) { should eq "" }
  end

  describe file(r[:path]) do
    it { should be_directory }
    it { should be_owned_by user }
  end

  describe file("#{r[:path]}/_site") do
    it { should be_directory }
    it { should be_owned_by user }
  end

  describe file("#{r[:path]}/_site/index.html") do
    it { should be_file }
    it { should be_owned_by user }
  end
end
