# frozen_string_literal: true

require 'spec_helper'

describe 'apt::backports', type: :class do
  let(:pre_condition) { 'include apt' }

  describe 'debian/ubuntu tests' do
    context 'with defaults on debian' do
      let(:facts) do
        {
          os: {
            family: 'Debian',
            name: 'Debian',
            release: {
              full: '11.8',
              major: '11',
              minor: '8'
            },
            distro: {
              codename: 'bullseye',
              id: 'Debian'
            }
          }
        }
      end

      it {
        expect(subject).to contain_apt__source('backports').with(
          location: 'http://deb.debian.org/debian',
          repos: 'main contrib non-free',
          release: 'bullseye-backports',
          pin: {
            'priority' => 200,
            'release' => 'bullseye-backports'
          },
          keyring: '/usr/share/keyrings/debian-archive-keyring.gpg',
        )
      }
    end

    context 'with defaults on ubuntu' do
      let(:facts) do
        {
          os: {
            family: 'Debian',
            name: 'Ubuntu',
            release: {
              major: '22.04',
              full: '22.04'
            },
            distro: {
              codename: 'jammy',
              id: 'Ubuntu'
            }
          }
        }
      end

      it {
        expect(subject).to contain_apt__source('backports').with(
          location: 'http://archive.ubuntu.com/ubuntu',
          repos: 'main universe multiverse restricted',
          release: 'jammy-backports',
          pin: {
            'priority' => 200,
            'release' => 'jammy-backports'
          },
          keyring: '/usr/share/keyrings/ubuntu-archive-keyring.gpg',
        )
      }
    end

    context 'with everything set' do
      let(:facts) do
        {
          os: {
            family: 'Debian',
            name: 'Ubuntu',
            release: {
              major: '22.04',
              full: '22.04'
            },
            distro: {
              codename: 'jammy',
              id: 'Ubuntu'
            }
          }
        }
      end
      let(:params) do
        {
          location: 'http://archive.ubuntu.com/ubuntu-test',
          release: 'vivid',
          repos: 'main',
          key: 'A1BD8E9D78F7FE5C3E65D8AF8B48AD6246925553',
          pin: '90'
        }
      end

      it {
        expect(subject).to contain_apt__source('backports').with(
          location: 'http://archive.ubuntu.com/ubuntu-test',
          key: 'A1BD8E9D78F7FE5C3E65D8AF8B48AD6246925553',
          repos: 'main',
          release: 'vivid',
          pin: { 'priority' => 90, 'release' => 'vivid' },
        )
      }
    end

    context 'when set things with hashes' do
      let(:facts) do
        {
          os: {
            family: 'Debian',
            name: 'Ubuntu',
            release: {
              major: '22.04',
              full: '22.04'
            },
            distro: {
              codename: 'jammy',
              id: 'Ubuntu'
            }
          }
        }
      end
      let(:params) do
        {
          key: {
            'id' => 'A1BD8E9D78F7FE5C3E65D8AF8B48AD6246925553'
          },
          pin: {
            'priority' => '90'
          }
        }
      end

      it {
        expect(subject).to contain_apt__source('backports').with(
          key: { 'id' => 'A1BD8E9D78F7FE5C3E65D8AF8B48AD6246925553' },
          pin: { 'priority' => '90' },
        )
      }
    end
  end

  describe 'linuxmint tests' do
    let(:facts) do
      {
        os: {
          family: 'Debian',
          name: 'LinuxMint',
          release: {
            major: '17',
            full: '17'
          },
          distro: {
            codename: 'qiana',
            id: 'LinuxMint'
          }
        }
      }
    end

    context 'with all the needed things set' do
      let(:params) do
        {
          location: 'http://archive.ubuntu.com/ubuntu',
          release: 'trusty-backports',
          repos: 'main universe multiverse restricted',
          key: '630239CC130E1A7FD81A27B140976EAF437D05B5'
        }
      end

      it {
        expect(subject).to contain_apt__source('backports').with(
          location: 'http://archive.ubuntu.com/ubuntu',
          key: '630239CC130E1A7FD81A27B140976EAF437D05B5',
          repos: 'main universe multiverse restricted',
          release: 'trusty-backports',
          pin: { 'priority' => 200, 'release' => 'trusty-backports' },
        )
      }
    end

    context 'with missing location' do
      let(:params) do
        {
          release: 'trusty-backports',
          repos: 'main universe multiverse restricted',
          key: '630239CC130E1A7FD81A27B140976EAF437D05B5'
        }
      end

      it do
        expect(subject).to raise_error(Puppet::Error, %r{If not on Debian or Ubuntu, you must explicitly pass location, release, and repos})
      end
    end

    context 'with missing release' do
      let(:params) do
        {
          location: 'http://archive.ubuntu.com/ubuntu',
          repos: 'main universe multiverse restricted',
          key: '630239CC130E1A7FD81A27B140976EAF437D05B5'
        }
      end

      it do
        expect(subject).to raise_error(Puppet::Error, %r{If not on Debian or Ubuntu, you must explicitly pass location, release, and repos})
      end
    end

    context 'with missing repos' do
      let(:params) do
        {
          location: 'http://archive.ubuntu.com/ubuntu',
          release: 'trusty-backports',
          key: '630239CC130E1A7FD81A27B140976EAF437D05B5'
        }
      end

      it do
        expect(subject).to raise_error(Puppet::Error, %r{If not on Debian or Ubuntu, you must explicitly pass location, release, and repos})
      end
    end
  end

  describe 'validation' do
    let(:facts) do
      {
        os: {
          family: 'Debian',
          name: 'Ubuntu',
          release: {
            major: '22.04',
            full: '22.04'
          },
          distro: {
            codename: 'jammy',
            id: 'Ubuntu'
          }
        }
      }
    end

    context 'with invalid location' do
      let(:params) do
        {
          location: true
        }
      end

      it do
        expect(subject).to raise_error(Puppet::Error, %r{expects a})
      end
    end

    context 'with invalid release' do
      let(:params) do
        {
          release: true
        }
      end

      it do
        expect(subject).to raise_error(Puppet::Error, %r{expects a})
      end
    end

    context 'with invalid repos' do
      let(:params) do
        {
          repos: true
        }
      end

      it do
        expect(subject).to raise_error(Puppet::Error, %r{expects a})
      end
    end

    context 'with invalid key' do
      let(:params) do
        {
          key: true
        }
      end

      it do
        expect(subject).to raise_error(Puppet::Error, %r{expects a})
      end
    end

    context 'with invalid pin' do
      let(:params) do
        {
          pin: true
        }
      end

      it do
        expect(subject).to raise_error(Puppet::Error, %r{expects a})
      end
    end
  end
end
