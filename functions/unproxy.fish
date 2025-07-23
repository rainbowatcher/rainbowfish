function unproxy
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

    function unset_cli_proxy --no-scope-shadowing
        if test (set -x | grep -Eic 'HTTP[S]?_PROXY') -gt 0
            begin
                set -e HTTP_PROXY
                set -e HTTPS_PROXY
                set -e http_proxy
                set -e https_proxy
            end
            judge "unset cli proxy"
        else
            $info "cli proxy has already unset"
        end
    end

    function unset_git_proxy --no-scope-shadowing
        if test (git config --global --get http.proxy)
            begin
                git config --global --unset http.proxy
                git config --global --unset https.proxy
            end
            judge "unset git proxy"
        else
            $info "git proxy has already unset"
        end
    end

    function unset_cargo_proxy --no-scope-shadowing
        test -z "$__CARGO_CONFIG_FILE"; and set --local __CARGO_CONFIG_FILE "$HOME/.cargo/config.yaml"
        if ! test -e "$__CARGO_CONFIG_FILE"
            $warn "cargo config not exists at: $__CARGO_CONFIG_FILE"
            return 1
        end
        if test (grep -c proxy "$__CARGO_CONFIG_FILE") -ge 1
            begin
                sed -ie '/^\[http/d' "$HOME/.cargo/config.yaml"
                sed -ie '/^proxy/d' "$HOME/.cargo/config.yaml"
            end
            judge "unset cargo proxy"
        else
            $info "cargo proxy has already unset"
        end
    end

    unset_cli_proxy
    unset_git_proxy
    unset_cargo_proxy
end
