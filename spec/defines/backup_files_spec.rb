# frozen_string_literal: true

require 'spec_helper'

describe 'restic::backup::files' do
  let(:title) { 'mybackup' }
  let(:params) do
    {
      paths: ['/very/important'],
      password: 'verysecret',
      repository: '/var/backup/mybackup',
      excludes: %w[/var/important/except_this /var/important/and_that],
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_class('restic::files') }

      it do
        is_expected.to contain_file('/etc/restic/mybackup.env').
          with_content("RESTIC_PASSWORD='verysecret'\nRESTIC_REPOSITORY='/var/backup/mybackup'\n")
      end

      it do
        is_expected.to contain_file('/etc/restic/mybackup.files').
          with_content("/very/important\n")
      end

      it do
        is_expected.to contain_file('/etc/restic/mybackup.exclude').
          with_content("/var/important/except_this\n/var/important/and_that\n/var/lib/restic\n")
      end

      it do
        is_expected.to contain_service('restic@mybackup.timer').
          that_requires(['File[/etc/restic/mybackup.env]',
                         'File[/etc/restic/mybackup.files]',
                         'File[/etc/restic/mybackup.exclude]'])
      end
    end
  end
end
