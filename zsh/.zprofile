# ~/.zprofile
VGA=$(lspci | grep 'Radeon Vega Series')

brillo -I

if [ "$(tty)" = "/dev/tty1" ]; then 
    if [ $VGA ]; then
        exec hl
    else
        #exec hl-nvidia
    fi
fi
