# JXA Pre-Processor

## Download
### Latest binaries
  * [x86_64](https://github.com/optimistiCli/jxapp/raw/latest_bin/bin/jxapp_1.0.0_x86_64.tar.gz)
  * [arm64](https://github.com/optimistiCli/jxapp/raw/latest_bin/bin/jxapp_1.0.0_arm64.tar.gz) Untested: I don't have access to apple silicon

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
    * probably a standalone Swift 5.4 will do &#x1F937;
  * git

### Building and installing
```bash
# Clone repo
git clone https://github.com/optimistiCli/jxapp.git
cd jxapp

# Run tests
git submodule init
git submodule update
./runtest.sh

# Build release
swift build -c release
sudo cp -iv .build/release/jxapp /usr/local/bin/
```

