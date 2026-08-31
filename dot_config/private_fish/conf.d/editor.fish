if not set -q EDITOR
    if type -q nvim
		set -gx EDITOR nvim
	else if type -q vim
		set -gx EDITOR vim
	else if type -q vi
		set -gx EDITOR vi
	end
end
