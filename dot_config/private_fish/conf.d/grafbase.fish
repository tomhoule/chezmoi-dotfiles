if not contains "$HOME/.grafbase/bin" $PATH
    fish_add_path "$HOME/.grafbase/bin"
end

abbr --add -- gbd 'uvx aws2-wrap --profile gb-api-dev-admin'
