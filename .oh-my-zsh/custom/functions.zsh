################################################################################
## Utility functions

## UUID - returns a v4 UUID (lower case)
function uuid() {
        uuid=$(uuidgen | tr "A-Z" "a-z");
        echo -n $uuid | pbcopy;
    echo $uuid;
}

## SHA1 - generates a sha1 hash of the input text
function sha1() {
        echo "Enter text:";
    read -s input;
    hashed=$(echo -n $input | openssl sha1);
    echo -n $hashed | pbcopy;
    echo $hashed;
}

## now - generates an ISO-8601 compliant date (copies it to the clipboard)
function now() {
    time=$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")
    echo -n $time | pbcopy;
    echo $time;
}

## generate an otp code
function otp() {
  if (( $# != 1 )); then
    echo "**Error**";
    echo "Usage:";
    echo "otp [path_to_secret]";
    return 1;
  fi;

  CODE=$(cat $1 | tr -d '\n' | xargs oathtool --base32 --totp);
  echo -n $CODE | pbcopy;
  echo $CODE;
}

## ssh_sg
function ssh_sg() {
    if (( $# < 1 )) || (( $# > 2 )); then
        echo "**Error**";
        echo "Usage:";
        echo "ssh_sg ip";
        return 1;
    fi;
    ssh -i ~/.signal_keys/ops@signal.uk.com.pem "ec2-user@"$1;
}

## ssh_ls
function ssh_ls() {
    if (( $# < 1)) || (( $# > 2 )); then
        echo "**Error**";
        echo "Usage:";
        echo "ssh_sl ip";
        return 1;
    fi;
    ssh -i ~/.keys/lightsail/lightsail.pem "ec2-user@"$1;
}

## to - touch and open a file in a single command
function to() {
        subl=""
        if (( $# < 1 )) || (( $# > 2 )); then
                echo "**Error**"
                echo "Usage:"
                echo "to file [-s]";
                return 1;
        elif [[ $2 == "-s" ]] || [[ $2 == "--subl" ]]; then
                subl=true;
        fi;

        touch $1;

        if [ $subl ]; then
                subl $1;
        else
                open $1;
        fi;
}

## tos - touch, open, sublime.
function tos() {
        to $1 "-s";
}

## load nvmrc
function load_nvmrc() {
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [ -n "$nvmrc_path" ]; then
        local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
        if [ "$nvmrc_node_version" != "N/A" ] && [ "$nvmrc_node_version" != "$node_version" ]; then
            nvm use
        fi
    elif [ "$node_version" != "$(nvm version default)" ]; then
        echo "Reverting to nvm default version"
        nvm use default
    fi
}

## wtf did i do today?
function did() {
    if [ ! -e ~/.did/notes.txt ]; then
        mkdir -p ~/.did
        echo -e "I can't believe i've done this...\n" >> ~/.did/notes.txt
    fi

    vim +'normal! G' +'r !date' +'normal! Go' ~/.did/notes.txt
}