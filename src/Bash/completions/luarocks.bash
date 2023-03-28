#!/usr/bin/env bash
# shellcheck shell=bash
# vi: ft=sh fdm=marker ts=2 sw=2 et
#
# Completion for luarocks.

function _luarocks() {
    local IFS=$' \t\n'
    local args cur prev cmd opts arg
    args=("${COMP_WORDS[@]}")
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="-h --help --version --dev --server --from --only-server --only-from --only-sources --only-sources-from --namespace --lua-dir --lua-version --tree --to --local --global --verbose --timeout --project-tree --pin --pack-binary-rock --branch --sign"

    case "$prev" in
        --server|--from)
            COMPREPLY=($(compgen -f -- "$cur"))
            return 0
            ;;
        --only-server|--only-from)
            COMPREPLY=($(compgen -f -- "$cur"))
            return 0
            ;;
        --only-sources|--only-sources-from)
            COMPREPLY=($(compgen -f -- "$cur"))
            return 0
            ;;
        --namespace)
            COMPREPLY=($(compgen -f -- "$cur"))
            return 0
            ;;
        --lua-dir)
            COMPREPLY=($(compgen -f -- "$cur"))
            return 0
            ;;
        --lua-version)
            COMPREPLY=($(compgen -f -- "$cur"))
            return 0
            ;;
        --tree|--to)
            COMPREPLY=($(compgen -f -- "$cur"))
            return 0
            ;;
        --timeout)
            COMPREPLY=($(compgen -f -- "$cur"))
            return 0
            ;;
        --project-tree)
            COMPREPLY=($(compgen -f -- "$cur"))
            return 0
            ;;
        --branch)
            COMPREPLY=($(compgen -f -- "$cur"))
            return 0
            ;;
    esac

    args=("${args[@]:1}")
    for arg in "${args[@]}"; do
        case "$arg" in
            help)
                cmd="help"
                opts="$opts -h --help"
                break
                ;;
            completion)
                cmd="completion"
                opts="$opts -h --help"
                break
                ;;
            build)
                cmd="build"
                opts="$opts -h --help --only-deps --deps-only --branch --no-install --no-doc --pack-binary-rock --keep --force --force-fast --verify --sign --check-lua-versions --pin --no-manifest --only-deps --deps-only --deps-mode --nodeps"
                break
                ;;
            config)
                cmd="config"
                opts="$opts -h --help --scope --unset --json --lua-incdir --lua-libdir --lua-ver --system-config --user-config --rock-trees"
                break
                ;;
            doc)
                cmd="doc"
                opts="$opts -h --help --home --list --porcelain"
                break
                ;;
            download)
                cmd="download"
                opts="$opts -h --help --all --source --rockspec --arch --check-lua-versions"
                break
                ;;
            init)
                cmd="init"
                opts="$opts -h --help --reset --output --license --summary --detailed --homepage --lua-versions --rockspec-format --tag --lib"
                break
                ;;
            install)
                cmd="install"
                opts="$opts -h --help --keep --force --force-fast --only-deps --deps-only --no-doc --verify --check-lua-versions --deps-mode --nodeps --no-manifest"
                break
                ;;
            lint)
                cmd="lint"
                opts="$opts -h --help"
                break
                ;;
            list)
                cmd="list"
                opts="$opts -h --help --outdated --porcelain"
                break
                ;;
            make)
                cmd="make"
                opts="$opts -h --help --no-install --no-doc --pack-binary-rock --keep --force --force-fast --verify --sign --check-lua-versions --pin --no-manifest --only-deps --deps-only --deps-mode --nodeps"
                break
                ;;
            new_version|new-version)
                cmd="new_version"
                opts="$opts -h --help --dir --tag"
                break
                ;;
            pack)
                cmd="pack"
                opts="$opts -h --help --sign"
                break
                ;;
            path)
                cmd="path"
                opts="$opts -h --help --no-bin --append --lr-path --lr-cpath --lr-bin --bin"
                break
                ;;
            purge)
                cmd="purge"
                opts="$opts -h --help --old-versions --force --force-fast"
                break
                ;;
            remove)
                cmd="remove"
                opts="$opts -h --help --force --force-fast --deps-mode --nodeps"
                break
                ;;
            search)
                cmd="search"
                opts="$opts -h --help --source --binary --all --porcelain"
                break
                ;;
            show)
                cmd="show"
                opts="$opts -h --help --home --modules --deps --build-deps --test-deps --rockspec --mversion --rock-tree --rock-namespace --rock-dir --rock-license --issues --labels --porcelain"
                break
                ;;
            test)
                cmd="test"
                opts="$opts -h --help --prepare --test-type"
                break
                ;;
            unpack)
                cmd="unpack"
                opts="$opts -h --help --force --check-lua-versions"
                break
                ;;
            upload)
                cmd="upload"
                opts="$opts -h --help --skip-pack --api-key --temp-key --force --sign --debug"
                break
                ;;
            which)
                cmd="which"
                opts="$opts -h --help"
                break
                ;;
            write_rockspec|write-rockspec)
                cmd="write_rockspec"
                opts="$opts -h --help --output --license --summary --detailed --homepage --lua-versions --rockspec-format --tag --lib"
                break
                ;;
        esac
    done

    case "${cmd-}" in
        '')
            COMPREPLY=($(compgen -W "help completion build config doc download init install lint list make new_version new-version pack path purge remove search show test unpack upload which write_rockspec write-rockspec" -- "$cur"))
            ;;
        'help')
            COMPREPLY=($(compgen -W "help completion build config doc download init install lint list make new_version new-version pack path purge remove search show test unpack upload which write_rockspec write-rockspec" -- "$cur"))
            ;;
        'build')
            case "$prev" in
                --branch)
                    COMPREPLY=($(compgen -f -- "$cur"))
                    return 0
                    ;;
                --deps-mode)
                    COMPREPLY=($(compgen -W "all one order none" -- "$cur"))
                    return 0
                    ;;
            esac

            ;;
        'config')
            case "$prev" in
                --scope)
                    COMPREPLY=($(compgen -W "system user project" -- "$cur"))
                    return 0
                    ;;
            esac

            ;;
        'download')
            case "$prev" in
                --arch)
                    COMPREPLY=($(compgen -f -- "$cur"))
                    return 0
                    ;;
            esac

            ;;
        'init')
            case "$prev" in
                --output)
                    COMPREPLY=($(compgen -f -- "$cur"))
                    return 0
                    ;;
                --license)
                    COMPREPLY=($(compgen -f -- "$cur"))
                    return 0
                    ;;
                --summary)
                    COMPREPLY=($(compgen -f -- "$cur"))
                    return 0
                    ;;
                --detailed)
                    COMPREPLY=($(compgen -f -- "$cur"))
                    return 0
                    ;;
                --homepage)
                    COMPREPLY=($(compgen -f -- "$cur"))
                    return 0
                    ;;
                --lua-versions)
                    COMPREPLY=($(compgen -W "5.1 5.2 5.3 5.4 5.1,5.2 5.2,5.3 5.3,5.4 5.1,5.2,5.3 5.2,5.3,5.4 5.1,5.2,5.3,5.4" -- "$cur"))
                    return 0
                    ;;
                --rockspec-format)
                    COMPREPLY=($(compgen -f -- "$cur"))
                    return 0
                    ;;
                --tag)
                    COMPREPLY=($(compgen -f -- "$cur"))
                    return 0
                    ;;
                --lib)
                    COMPREPLY=($(compgen -f -- "$cur"))
                    return 0
                    ;;
            esac

            ;;
        'install')
            case "$prev" in
                --deps-mode)
                    COMPREPLY=($(compgen -W "all one order none" -- "$cur"))
                    return 0
                    ;;
            esac

            ;;
        'make')
            case "$prev" in
                --deps-mode)
                    COMPREPLY=($(compgen -W "all one order none" -- "$cur"))
                    return 0
                    ;;
            esac

            ;;
        'new_version')
            case "$prev" in
                --dir)
                    COMPREPLY=($(compgen -f -- "$cur"))
                    return 0
                    ;;
                --tag)
                    COMPREPLY=($(compgen -f -- "$cur"))
                    return 0
                    ;;
            esac

            ;;
        'remove')
            case "$prev" in
                --deps-mode)
                    COMPREPLY=($(compgen -W "all one order none" -- "$cur"))
                    return 0
                    ;;
            esac

            ;;
        'test')
            case "$prev" in
                --test-type)
                    COMPREPLY=($(compgen -f -- "$cur"))
                    return 0
                    ;;
            esac

            ;;
        'upload')
            case "$prev" in
                --api-key)
                    COMPREPLY=($(compgen -f -- "$cur"))
                    return 0
                    ;;
                --temp-key)
                    COMPREPLY=($(compgen -f -- "$cur"))
                    return 0
                    ;;
            esac

            ;;
        'write_rockspec')
            case "$prev" in
                --output)
                    COMPREPLY=($(compgen -f -- "$cur"))
                    return 0
                    ;;
                --license)
                    COMPREPLY=($(compgen -f -- "$cur"))
                    return 0
                    ;;
                --summary)
                    COMPREPLY=($(compgen -f -- "$cur"))
                    return 0
                    ;;
                --detailed)
                    COMPREPLY=($(compgen -f -- "$cur"))
                    return 0
                    ;;
                --homepage)
                    COMPREPLY=($(compgen -f -- "$cur"))
                    return 0
                    ;;
                --lua-versions)
                    COMPREPLY=($(compgen -W "5.1 5.2 5.3 5.4 5.1,5.2 5.2,5.3 5.3,5.4 5.1,5.2,5.3 5.2,5.3,5.4 5.1,5.2,5.3,5.4" -- "$cur"))
                    return 0
                    ;;
                --rockspec-format)
                    COMPREPLY=($(compgen -f -- "$cur"))
                    return 0
                    ;;
                --tag)
                    COMPREPLY=($(compgen -f -- "$cur"))
                    return 0
                    ;;
                --lib)
                    COMPREPLY=($(compgen -f -- "$cur"))
                    return 0
                    ;;
            esac

            ;;
    esac

    if [[ "$cur" = -* ]]; then
        COMPREPLY=($(compgen -W "$opts" -- "$cur"))
    fi
}

complete -F _luarocks -o bashdefault -o default luarocks
