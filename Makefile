update:
	export UPDATER_ROOT=$$(pwd); cd ex && mix update

umbrellas:
	export UPDATER_ROOT=$$(pwd); cd ex && mix umbrellas


readme:
	export UPDATER_ROOT=$$(pwd); cd ex && mix readme

size:
	du -sh src/github.com/* | sort -h
