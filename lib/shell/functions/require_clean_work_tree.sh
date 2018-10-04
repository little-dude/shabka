require_clean_work_tree () {
    local action err

	git rev-parse --verify HEAD >/dev/null || exit 1
	git update-index -q --ignore-submodules --refresh
	err=0

	if ! git diff-files --quiet --ignore-submodules
	then
		action=$1
		case "$action" in
		rebase)
			echo "Cannot rebase: You have unstaged changes." >&2
			;;
		"rewrite branches")
			echo "Cannot rewrite branches: You have unstaged changes." >&2
			;;
		"pull with rebase")
			echo "Cannot pull with rebase: You have unstaged changes." >&2
			;;
		*)
			echo "Cannot \$action: You have unstaged changes." >&2
			;;
		esac
		err=1
	fi

	if ! git diff-index --cached --quiet --ignore-submodules HEAD --
	then
		if test $err = 0
		then
			action=$1
			case "$action" in
			rebase)
				echo "Cannot rebase: Your index contains uncommitted changes." >&2
				;;
			"pull with rebase")
				echo "Cannot pull with rebase: Your index contains uncommitted changes." >&2
				;;
			*)
				echo "Cannot \$action: Your index contains uncommitted changes." >&2
				;;
			esac
		else
		    echo "Additionally, your index contains uncommitted changes." >&2
		fi
		err=1
	fi

	if test $err = 1
	then
		test -n "$2" && echo "$2" >&2
		exit 1
	fi
}
