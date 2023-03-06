# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'restic' do
  include_examples 'an idempotent resource' do
    let(:manifest) { 'include restic' }
  end

  it { expect(package('restic')).to be_installed }

  it do
    expect(user('restic')).to exist.
      and(belong_to_group('restic')).
      and(have_home_directory('/var/lib/restic')).
      and(have_login_shell('/usr/sbin/nologin'))
  end

  it { expect(group('restic')).to exist }
  it { expect(file('/var/lib/restic')).to be_directory }
  it { expect(file('/etc/restic')).to be_directory }
end
