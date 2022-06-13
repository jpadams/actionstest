package test

import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"
)

dagger.#Plan & {
	client: {
		env: {
			GITHUB_REF: string
		}
		commands: {
			version: {
				name: "bash"
				args: ["-c", #"""
					set -e
					[[ \#(client.env.GITHUB_REF) =~ "refs/tags/" ]] && \
					echo \#(client.env.GITHUB_REF) | sed -e 's/^refs\/tags\/v//' | tr -d "[:space:]"
					"""#]
			}
		}
	}
	actions: {
		test: core.#Nop & {input: client.commands.version.stdout}
	}
}
