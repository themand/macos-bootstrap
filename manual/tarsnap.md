# Tarsnap

#### Install dependencies

Install openssl-devel if not already installed

```bash
brew install openssl
```

Make openssl-devel available to compilers:

```bash
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"
```

#### Download and verify Tarsnap

[Download](https://www.tarsnap.com/download.html#source) source code and signed SHA256 file

Receive Tarsnap signing key if not already present:

```bash
gpg --list-keys 22963D18296B6B6D7DDAFC936B0EDCFADDF5CD05 || gpg --receive-key 22963D18296B6B6D7DDAFC936B0EDCFADDF5CD05
```

Decrypt SHA256 signature (complete filename):

```bash
gpg --decrypt tarsnap-sigs-1.
```

Check SHA256 sum of downloaded archive (complete filename):

```bash
shasum -a 256 tarsnap-autoconf-1.
```

**Make sure it matches signature decrypted in previous step.**

#### Compile tarsnap

Extract source code archive (complete filenames).

```bash
tar zxf tarsnap-autoconf-1.
```
```bash
cd tarsnap-autoconf-1.
```

Compile

```bash
./configure && make all
```

Install tarsnap:
```bash
sudo make install
```

#### Configure

@todo