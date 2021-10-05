# JXA Pre-Processor

## Download
### Latest binaries
  * [x86_64](https://github.com/optimistiCli/jxapp/raw/latest_bin/bin/jxapp_x86_64.tar.gz)
  * [arm64](https://github.com/optimistiCli/jxapp/raw/latest_bin/bin/jxapp_arm64.tar.gz) Untested: I don't have access to apple silicon, alas :man_shrugging:

### Downloading and installing
```bash
wget https://github.com/optimistiCli/jxapp/raw/latest_bin/bin/jxapp_x86_64.tar.gz
tar xf jxapp_x86_64.tar.gz
sudo mv -iv jxapp /usr/local/bin/
```

## Build

### Prerequisites
  * macOS
  * Xcode 12.5
  * git
  * swift 5.4

### Building and installing
```bash
git clone https://github.com/optimistiCli/jxapp.git
cd jxapp
./runtest.sh
swift build -c release
sudo cp -iv .build/release/jxapp /usr/local/bin/
```
