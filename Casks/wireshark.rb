cask 'wireshark' do
  version '3.2.3'
  sha256 '066a05b20dce30f55a9ae8543cdf62771250352ab74c93186b8fb8a37a3aaf18'

  url "https://1.na.dl.wireshark.org/osx/all-versions/Wireshark%20#{version}%20Intel%2064.dmg"
  appcast 'https://www.wireshark.org/update/0/Wireshark/0.0.0/macOS/x86-64/en-US/stable.xml'
  name 'Wireshark'
  homepage 'https://www.wireshark.org/'

  auto_updates true
  conflicts_with cask: 'wireshark-chmodbpf'
  depends_on macos: '>= :sierra'

  app 'Wireshark.app'
  pkg 'Install ChmodBPF.pkg'
  pkg 'Add Wireshark to the system path.pkg'

  uninstall_preflight do
    set_ownership '/Library/Application Support/Wireshark'

    if File.read('/etc/group').match?(%r{^access_bpf})
      system_command '/usr/sbin/dseditgroup',
                     args: ['-o', 'delete', 'access_bpf'],
                     sudo: true
    end
  end

  uninstall pkgutil:   'org.wireshark.*',
            launchctl: 'org.wireshark.ChmodBPF'

  zap trash: '~/Library/Saved Application State/org.wireshark.Wireshark.savedState'
end
