#!/bin/bash

SOURCE=$1
ENC_SOURCE_NAME=$SOURCE.enc
AES_KEY=$(openssl rand -hex 16)
AES_IV=$(openssl rand -hex 16)

if [ -z "$1" ]
  then
    echo "Please provide an argument."
    echo "- First argument: the file you want to encrypt."
    exit
fi

pv $SOURCE | openssl enc -aes-128-cbc -K $AES_KEY -iv $AES_IV -out $ENC_SOURCE_NAME

# Copy permissions from old file to new file
chmod --reference=$SOURCE $ENC_SOURCE_NAME

SIZE_SOURCE=$(stat -c%s $SOURCE)
SIZE_ENC_SOURCE=$(stat -c%s $ENC_SOURCE_NAME)

# We grab the first 17 bytes of the encrypted data, hash it and use the first 16 bytes of that has in the filename
# This is "safe enough".
# The decrypt script uses the reverse logic to detect the keyfile. So don't change the keyfile beyond ".key."!
FIRST_16_BYTES_ENC_HEX=$(head -c 16 $ENC_SOURCE_NAME | hexdump -e '16/1 "%02x" "\n"' | sha256sum | cut -f1 -d' ' | cut -c1-16)
KEYS_SOURCE_NAME=$SOURCE.keys.$FIRST_16_BYTES_ENC_HEX

cat << EOF > $KEYS_SOURCE_NAME
export AES_KEY=$AES_KEY
export AES_IV=$AES_IV
EOF

cat << EOF
$SOURCE -> $SIZE_SOURCE bytes
$ENC_SOURCE_NAME -> $SIZE_ENC_SOURCE bytes
EOF

echo ""

read -p "Delete source file ($SOURCE)? [yn] " yn
  case $yn in
    [Yy]* ) rm $SOURCE;;
    [Nn]* ) exit;;
  * ) echo "Please answer yes or no.";;
esac
