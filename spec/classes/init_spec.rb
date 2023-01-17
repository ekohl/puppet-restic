# frozen_string_literal: true

require 'spec_helper'

describe 'restic' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('restic') }
      it { is_expected.to contain_group('restic') }
      it { is_expected.to contain_user('restic') }
      it { is_expected.to contain_file('/var/lib/restic') }
      it { is_expected.to contain_file('/etc/restic') }
    end
  end
end
