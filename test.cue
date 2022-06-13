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
				name: "sh"
				args: ["-c", #"""
					[[ \#(client.env.GITHUB_REF) =~ "refs/tags/" ]] && \
					echo \#(client.env.GITHUB_REF) | sed 's/^refs\/tags\/v//' | tr -d "[:space:]"
					"""#]
				stdout: string
			}
		}
	}
	actions: {
		test: core.#Nop & {input: client.commands.version.stdout}
	}
}
