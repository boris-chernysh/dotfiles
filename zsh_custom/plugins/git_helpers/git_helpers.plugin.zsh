
function diff_edit() {
	if [ -z "$1" ]; then
		$EDITOR $(git diff --name-only)
	else
		$EDITOR $(git diff "$1" --name-only)
	fi
}

function branch_load() {
	if [[ -z "$1" ]]; then
		git pull origin "$(git branch | grep '^*' | cut -d' ' -f2)"
	else
		git fetch origin "$1"
		git checkout "$1"
	fi
}

function branch_new() {
	git branch "$1"
	git checkout "$1"
}
