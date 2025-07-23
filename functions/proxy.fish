function proxy
    set -f info echo (set_color brgreen)INFO (set_color normal)
    set -f warn echo (set_color bryellow)WARN (set_color normal)
    set -f error echo (set_color brred)ERROR (set_color normal)

    function judge --no-scope-shadowing --argument-names msg
        if test $status != 0
            $error "$msg failed"
        else
            $info "$msg succeed"
        end
    end

    if test -z $HTTP_PROXY_ADDR
        echo (set_color yellow --bold)WARN (set_color normal) "must set env var \$HTTP_PROXY_ADDR first"
        return 0
    end

    function set_cli_proxy --no-scope-shadowing
        if test (set -x | grep -Eic 'HTTP[S]?_PROXY') -lt 2
            begin
                set -xU HTTP_PROXY $HTTP_PROXY_ADDR
                set -xU HTTPS_PROXY $HTTP_PROXY_ADDR
                set -xU http_proxy $HTTP_PROXY_ADDR
                set -xU https_proxy $HTTP_PROXY_ADDR
            end
            judge "set cli proxy to '$HTTP_PROXY_ADDR'"
        else
            $info "cli proxy has already set"
        end
    end

    function set_git_proxy --no-scope-shadowing
        if not test (git config --get http.proxy)
            begin
                git config --global http.proxy $HTTP_PROXY_ADDR
                git config --global https.proxy $HTTP_PROXY_ADDR
            end
            judge "set git proxy to '$HTTP_PROXY_ADDR'"
        else
            $info "git proxy has already set"
        end
    end

    function set_cargo_proxy --no-scope-shadowing
        test -z "$__CARGO_CONFIG_FILE"; and set --local __CARGO_CONFIG_FILE "$HOME/.cargo/config.yaml"
        if ! test -e "$__CARGO_CONFIG_FILE"
            $warn "cargo config not exists at: $__CARGO_CONFIG_FILE"
            return 1
        end
        if test (grep -c proxy "$__CARGO_CONFIG_FILE") -eq 1
            $info "cargo proxy has already set"
        else
            set -l proxy_addr (string sub -s 8 $HTTP_PROXY_ADDR)
            echo -e "[http]\nproxy=\"$proxy_addr\"" >>"$__CARGO_CONFIG_FILE"
            judge "set cargo proxy to '$HTTP_PROXY_ADDR'"
        end
    end

    set_cli_proxy
    set_git_proxy
    set_cargo_proxy
end
