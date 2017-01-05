#
# vim:ft=zsh:fenc=UTF-8:ts=4:sts=4:sw=4:expandtab:foldmethod=marker:foldlevel=0:
#
# Some functions are taken from
#       http://phraktured.net/config/
#       http://www.downgra.de/dotfiles/

# c()#{{{
function c() {
    local cmd flags archive files answer
    if [ "${#}" -gt "1" ]; then
        archive="${1}"
        shift
        files="${@}"
        if [ -f "${archive}" ]; then
            print_info 1 "The destination file '${archive}' already exists, overwride [y/n] " false
            read answer; echo
            if isTrue "${answer}"; then
                rm -f -- "${archive}"
            else
                print_warning 0 "Aborting..."
                return 1
            fi
        fi

        case "${archive}" in
            *.tar.bz2)
                cmd="tar"
                flags="cjf"
                ;;
            *.tar.gz)
                cmd="tar"
                flags="czf"
                ;;
            *.bz2)
                cmd="bzip2"
                flags=""
                archive="" # Bzip2 takes one Argument
                ;;
            *.rar)
                cmd="rar"
                flags="c"
                ;;
            *.gz)
                cmd="gzip"
                flags=""
                archive="" # gzip takes one Argument
                ;;
            *.tar)
                cmd="tar"
                flags="cf"
                ;;
            *.jar)
                cmd="jar cf"
                flags="cf"
                ;;
            *.tbz2)
                cmd="tar"
                flags="cjf"
                ;;
            *.tgz)
                cmd="tar"
                flags="czf"
                ;;
            *.zip|*.xpi)
                cmd="zip"
                flags="-r"
                ;;
                # TODO .Z and .7z formats
                *)
                print_error 0 "'${archive}' is not a valid archive type i am aware of."
                return 1
                ;;
        esac
        # Ok extract it now but first let's see if the progam can be used
        if ! type "${cmd}" &>/dev/null; then
            print_error 0 "I couldn't find the program '${cmd}', Please make sure it is installed."
            return 1
        fi
        ${cmd} ${flags} ${archive} ${files}
        if [ "${?}" -ne "0" ]; then
            print_error 0 "Oops an error occured..."
            return 1
        else
            print_info 0 'Archive has been successfully Created!'
        fi
    else
        print_error 0 "USAGE: c <Archive name> <Files and/or folders>"
        return 1
    fi
}
#}}}
