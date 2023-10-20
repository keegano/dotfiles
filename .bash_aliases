
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if command -v nvim &> /dev/null
then
    alias vim=nvim
    alias vi=nvim
fi

alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias bd='cd "$OLDPWD"'

alias mkdir='mkdir -pv'
alias sha1='openssl sha1'
alias j='jobs -l'

function install_nvim () {
	if [ -n "$DEBIAN" ]; then
		curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.deb --output nvim-linux64.deb
		sudo apt install ./nvim-linux64.deb
	else
		mkdir -p "$HOME/.local/bin"
		curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage --output "$HOME/.local/bin/nvim"
		chmod +x "$HOME/.local/bin/nvim"
	fi
	git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
}

function import_host_certs_wsl () {
    powershell.exe -c - << 'EOF'
$certificateType = [System.Security.Cryptography.X509Certificates.X509Certificate2]

$includedStores = @("TrustedPublisher", "Root", "CA", "AuthRoot")

$certificates = $includedStores.ForEach({
    Get-ChildItem Cert:\CurrentUser\$_ | Where-Object { $_ -is $certificateType}
})

$pemCertificates = $certificates.ForEach({
    $pemCertificateContent = [System.Convert]::ToBase64String($_.RawData,1)
    "-----BEGIN CERTIFICATE-----`n${pemCertificateContent}`n-----END CERTIFICATE-----"
})

$uniquePemCertificates = $pemCertificates | select -Unique

($uniquePemCertificates | Out-String).Replace("`r", "") | Out-File -Encoding UTF8 win-ca-certificates.crt
EOF
    NUM_CERTS=$(grep "BEGIN CERTIFICATE" win-ca-certificates.crt | wc -l)
    echo "Importing $NUM_CERTS certificates from host..."
    # chomp trailing newline
    # perl -pi -e 'chomp if eof' win-ca-certificates.crt
    sudo mv win-ca-certificates.crt /usr/local/share/ca-certificates/
	sudo update-ca-certificates -f
}

function install_handy_packages () {
    sudo apt install ripgrep fd-find fzf build-essential git bat tree tmux
}

function install_fonts {
    # TODO: don't clone the whole repo, it's huge
    git clone https://github.com/ryanoasis/nerd-fonts.git "$HOME/.nerd_fonts"
    pushd "$HOME/.nerd_fonts"
    if command -v powershell.exe &> /dev/null
    then
        # We on Windows
        powershell.exe -c "./install.ps1 Meslo, JetBrainsMono"
        # Also, let's connect up any fonts we've installed in Windows so they're
        # available in the VM (eg, for Inkscape)
        enable_windows_fonts

    else
        bash ./install.sh Meslo, JetBrainsMono
    fi
}

function enable_windows_fonts {
        sudo tee /etc/fonts/local.conf << 'EOF'
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
    <dir>/mnt/c/Windows/Fonts</dir>
</fontconfig>
EOF
}

alias dgit='git --git-dir ~/.dotfiles/.git --work-tree=$HOME'

