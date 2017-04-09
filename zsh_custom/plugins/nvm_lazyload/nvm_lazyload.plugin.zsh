if [[ ! $(declare -f  nvm) ]]; then
	function initNvm() {
		unalias node
		unalias npm
		unalias nvm

		source $NVM_INIT_SCRIPT
	}

	function nodeWrapper() {
		initNvm
		node "$@"
	}
	alias node=nodeWrapper

	function npmWrapper() {
		initNvm
		npm "$@"
	}
	alias npm=npmWrapper

	function nvmWrapper() {
		initNvm
		nvm "$@"
	}
	alias nvm=nvmWrapper
fi
