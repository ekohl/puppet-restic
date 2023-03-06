# frozen_string_literal: true

require 'spec_helper'

describe 'restic::files' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('restic') }

      it do
        is_expected.to contain_systemd__timer('restic@.timer').
          with(timer_content: %r{^OnCalendar=\*-\*-\* 2:00:00$}, service_content: %r{^User=restic$}).
          that_requires('Class[restic]')
      end
    end
  end
end
